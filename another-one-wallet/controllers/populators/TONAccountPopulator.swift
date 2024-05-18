//
//  TONAccountPopulator.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 16.05.2024.
//

import Foundation

class TONAccountPopulator : AccountPopulator {
    override func populate(account: BankAccount, address: String) async throws {
        guard let balanceDetails = try? await fetchAccountInfo(address: account.address) else {
            return
        }
        
        account.balance = 0.0
        
        let normalizedBalance = (Double(balanceDetails.result.balance) ?? 0.0) / 1000000000.0
        let tokenEntity = account.getCryptoTokenByAbbr(abbr: "ton") ?? CryptoToken(context: viewContext)
        tokenEntity.balance = String(normalizedBalance)
        tokenEntity.logo = "https://ton.org/download/ton_symbol.png"
        tokenEntity.name = "TON"
        tokenEntity.id = UUID()
        tokenEntity.abbr = "ton"
        
        if let tokenDetails = try? await CoinGeckoClient.shared.fetchTokenDetails(currency: "the-open-network", opposite: "usd") {
            tokenEntity.usdBalance = String(tokenDetails.currentPrice * Double(normalizedBalance))
            
            account.balance = tokenDetails.currentPrice * Double(normalizedBalance)
        }
        
        if account.getCryptoTokenByAbbr(abbr: "ton") == nil {
            account.addToTokens(tokenEntity)
        }
    }
    
    private func fetchAccountInfo(address: String?) async throws -> TONAccountResponse? {
        guard let address = address else {
            return nil
        }
        
        return try await TONClient.shared.fetchAccountInfo(address: address)
    }
}
