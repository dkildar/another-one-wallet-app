//
//  CryptoAccountsController.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 11.04.2024.
//

import Foundation
import CoreData
import SwiftUI
import Combine

class CryptoAccountsController : ObservableObject {
    @Published var accounts: [UUID : BankAccount] = [:]
    
    var context = PersistenceController.shared.container.viewContext
    var cancellable: Set<AnyCancellable> = Set()
    
    func loadAccounts() {
        let request: NSFetchRequest<BankAccount> = BankAccount.fetchRequest()
        request.sortDescriptors = []
        
        Task {
            do {
                let results = try context.fetch(request).filter { account in
                    BankAccountType.init(rawValue: account.type) == .LinkedCrypto
                }
                
                for account in results {
                    await populateAccount(account: account)
                }
                
                // Update cached balance
                PersistenceController.shared.save()
            } catch {
                print("Crypto accounts fetch failed")
            }
        }
    }
    
    private func populateAccount(account: BankAccount) async {
        guard let address = account.address else { return }
        
        switch AppCurrency.CryptoNetwork.init(rawValue: account.cryptoNetwork ?? "") {
        case .TRC20:
            try? await TRC20AccountPopulator(viewContext: context)
                .populate(account: account, address: address)
            
            try? context.save()
        case .SOL:
            try? await SolanaAccountPopulator(viewContext: context)
                .populate(account: account, address: address)
            
            try? context.save()
        case .none:
            return
        }
    }
}
