//
//  CryptoAccountDetailsView.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 15.04.2024.
//

import SwiftUI
import Pigeon

struct CryptoAccountDetailsView: View {
    @EnvironmentObject var persistenceController: PersistenceController
    
    @ObservedObject var transfersQuery = Query<String, TRC20TransfersResponse>(
        key: .trc20Transfers,
        keyAdapter: { key, address in key.appending(address) },
        behavior: .startWhenRequested,
        cache: UserDefaultsQueryCache.shared,
        cacheConfig: QueryCacheConfig(
            invalidationPolicy: .expiresAfter(300),
            usagePolicy: .useAndThenFetch
        ),
        fetcher: { address in
            TRC20Client.shared.fetchTransfers(address: address, limit: 20)
        })
    
    var account: BankAccount
    var token: CryptoToken
    
    init(account: BankAccount, token: CryptoToken) {
        self.account = account
        self.token = token
    }
    
    var body: some View {
        VStack {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(String(format: "%.2f", (Double(token.balance ?? "0") ?? 0)))
                                .foregroundStyle(.blue)
                                .font(.system(size: 28, weight: .semibold))
                            
                            Spacer()
                            
                            Text(token.abbr?.uppercased() ?? "")
                                .foregroundStyle(.gray)
                        }
                        Text("≈ " + String(format: "%.2f", (Double(token.usdBalance ?? "0") ?? 0)) + "$")
                            .foregroundStyle(.gray)
                        
                        let originalBalance = (Double(token.usdBalance ?? "0.0") ?? 0.0) / (Double(token.balance ?? "0.0") ?? 0.0)
                        Text("1\(token.abbr?.uppercased() ?? "") = \(String(format: "%.2f", originalBalance))$")
                            .foregroundStyle(.gray)
                            .font(.caption)
                            .padding(.top, 8)
                    }
                }
                .padding(.vertical, 8)
                
                if account.cryptoNetwork == AppCurrency.CryptoNetwork.TRC20.rawValue {
                    TRC20TokenDetails(
                        account: .constant(account),
                        token: .constant(token),
                        transfers: .constant(transfersQuery.state.value)
                    )
                }
            }
        }
        .onAppear {
            switch AppCurrency.CryptoNetwork.init(rawValue: account.cryptoNetwork!) {
            case .TRC20: transfersQuery.refetch(request: account.address ?? "")
            default: return
            }
        }
    }
}
