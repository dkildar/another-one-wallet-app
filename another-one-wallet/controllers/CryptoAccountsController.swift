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
        switch AppCurrency.CryptoNetwork.init(rawValue: account.cryptoNetwork ?? "") {
        case .TRC20:
            guard let details = try? await fetchTRC20Account(address: account.address) else { return }
            
            // TODO: CALCULATE WITH PRICE AND WITH ALL TOKENS
            account.balance = Double(details.balance ?? 0)
            
            account.tokens = []
            details.withPriceTokens?.forEach { token in
                let tokenEntity = CryptoToken(context: self.context)
                tokenEntity.id = UUID()
                tokenEntity.name = token.tokenName
                tokenEntity.balance = token.balance
                tokenEntity.logo = token.tokenLogo
                account.addToTokens(tokenEntity)
            }
            try? context.save()
        case .none:
            return
        case .some(.SOL):
            return
        }
    }
    
    private func fetchTRC20Account(address: String?) async throws -> TRC20AccountResponse? {
        guard let address = address else {
            return nil
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            Task {
                await TRC20Client.shared.fetchAccount(address: address)
                    .sink(
                        receiveCompletion: { completion in
                            if case let .failure(error) = completion {
                                debugPrint("TRC20 account fetching failed with \(error)")
                                continuation.resume(throwing: error)
                            }
                        },
                        receiveValue: { response in
                            continuation.resume(returning: response)
                        }
                    )
                    .store(in: &cancellable)
            }
        }
    }
}
