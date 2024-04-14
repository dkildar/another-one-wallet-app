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
            guard let details = try? await fetchTRC20AccountTokens(address: account.address) else { return }
            
            account.balance = 0.0
            account.tokens = []
            
            details.data?.forEach { token in
                let tokenEntity = CryptoToken(context: self.context)
                tokenEntity.id = UUID()
                tokenEntity.name = token.tokenName
                tokenEntity.balance = token.quantity
                tokenEntity.usdBalance = String(token.amountInUsd ?? 0.0)
                tokenEntity.logo = token.tokenLogo
                tokenEntity.abbr = token.tokenAbbr
                account.addToTokens(tokenEntity)
                
                account.balance += (token.amountInUsd ?? 0.0)
            }
            
            try? context.save()
        case .SOL:
            guard let balanceDetails = try? await fetchSOLAccountBalance(address: account.address) else {
                return
            }
            
            account.balance = 0.0
            account.tokens = []
            
            let normalizedBalance = Double(balanceDetails.result.value) / 1000000000.0
            let tokenEntity = CryptoToken(context: self.context)
            tokenEntity.balance = String(normalizedBalance)
            tokenEntity.logo = "https://solana.com/src/img/branding/solanaLogoMark.png"
            tokenEntity.name = "Solana"
            tokenEntity.id = UUID()
            tokenEntity.abbr = "sol"
            
            let usdBalance = try? await fetchCoinGeckoPrice(currency: "solana", vsCurrency: "usd")
            
            tokenEntity.usdBalance = String(usdBalance?.solana?.usd ?? 0.0 * Double(normalizedBalance))
            
            account.balance = (usdBalance?.solana?.usd ?? 0.0) * Double(normalizedBalance)
            account.addToTokens(tokenEntity)
            
            try? context.save()
        case .none:
            return
        }
    }
    
    private func fetchTRC20AccountTokens(address: String?) async throws -> TRC20TokensResponse? {
        guard let address = address else {
            return nil
        }
        
        return try await wrapApiRequest(request: TRC20Client.shared.fetchTokens(address: address))
    }
    
    private func fetchSOLAccountBalance(address: String?) async throws -> SolanaBalanceRPCResponse? {
        guard let address = address else {
            return nil
        }
        
        return try await wrapApiRequest(request: SolanaClient.shared.fetchBalance(address: address))
    }
    
    private func fetchCoinGeckoPrice(currency: String, vsCurrency: String) async throws -> CoinGeckoPriceResponse? {
        return try await wrapApiRequest(request: CoinGeckoClient.shared.fetchPrice(currency: currency, opposite: vsCurrency))
    }
    
    private func wrapApiRequest<T>(request: AnyPublisher<T, Error>) async throws -> T? {
        return try await withCheckedThrowingContinuation { continuation in
            Task {
                request
                    .sink(
                        receiveCompletion: { completion in
                            if case let .failure(error) = completion {
                                debugPrint("Account fetching failed with \(error)")
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
