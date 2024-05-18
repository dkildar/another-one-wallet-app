//
//  SolanaAccountPopulator.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 15.04.2024.
//

import Foundation
import CoreData

class SolanaAccountPopulator : AccountPopulator {
    override func populate(account: BankAccount, address: String) async throws {
        guard let balanceDetails = try? await fetchSOLAccountBalance(address: account.address) else {
            return
        }
        
        account.balance = 0.0
        
        let existingToken = account.getCryptoTokenByAbbr(abbr: "sol")
        let normalizedBalance = Double(balanceDetails.result.value) / 1000000000.0
        let tokenEntity = existingToken ?? CryptoToken(context: viewContext)
        tokenEntity.balance = String(normalizedBalance)
        tokenEntity.logo = "https://solana.com/src/img/branding/solanaLogoMark.png"
        tokenEntity.name = "Solana"
        tokenEntity.abbr = "sol"
        
        if let tokenDetails = try? await CoinGeckoClient.shared.fetchTokenDetails(currency: "solana", opposite: "usd") {
            tokenEntity.usdBalance = String(tokenDetails.currentPrice * Double(normalizedBalance))
            
            account.balance = tokenDetails.currentPrice * Double(normalizedBalance)
        }
    
        if existingToken == nil {
            tokenEntity.id = UUID()
            account.addToTokens(tokenEntity)
        }
    }
    
    private func fetchSOLAccountBalance(address: String?) async throws -> SolanaBalanceRPCResponse? {
        guard let address = address else {
            return nil
        }
        
        return try await SolanaClient.shared.fetchBalance(address: address)
    }
}
