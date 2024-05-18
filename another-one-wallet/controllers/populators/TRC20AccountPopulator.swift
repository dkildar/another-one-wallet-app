//
//  TRC20AccountPopulator.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 15.04.2024.
//

import Foundation
import CoreData

class TRC20AccountPopulator : AccountPopulator {
    override func populate(account: BankAccount, address: String) async throws {
        guard let details = try? await fetchTRC20AccountTokens(address: account.address) else { return }
        
        account.balance = 0.0
        
        details.data?.forEach { token in
            let existingToken = account.getCryptoTokenByAbbr(abbr: token.tokenAbbr ?? "")
            let tokenEntity = existingToken ?? CryptoToken(context: viewContext)
            tokenEntity.name = token.tokenName
            tokenEntity.balance = token.quantity
            tokenEntity.usdBalance = String(token.amountInUsd ?? 0.0)
            tokenEntity.logo = token.tokenLogo
            tokenEntity.abbr = token.tokenAbbr
            
            if existingToken == nil {
                tokenEntity.id = UUID()
                account.addToTokens(tokenEntity)
            }
            
            account.balance += (token.amountInUsd ?? 0.0)
        }
    }
    
    private func fetchTRC20AccountTokens(address: String?) async throws -> TRC20TokensResponse? {
        guard let address = address else {
            return nil
        }
        
        return try await TRC20Client.shared.fetchTokens(address: address)
    }
}
