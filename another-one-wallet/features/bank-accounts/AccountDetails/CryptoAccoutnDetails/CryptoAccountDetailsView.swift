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
    @StateObject var stateObject = CryptoAccountDetailsViewModel()
    
    @Binding var account: BankAccount
    @Binding var token: CryptoToken
    
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
                
                switch AppCurrency.CryptoNetwork.init(rawValue: account.cryptoNetwork!) {
                case .TRC20:
                    if token.abbr == AppCurrency.CryptoCurrencies.USDT.rawValue {
                        TRC20UsdtTokenDetails(
                            stateObject: stateObject, 
                            account: $account,
                            token: $token
                        )
                    }
                default: EmptyView()
                }
            }
        }
        .onAppear {
            switch AppCurrency.CryptoNetwork.init(rawValue: account.cryptoNetwork!) {
            case .TRC20: 
                if token.abbr == AppCurrency.CryptoCurrencies.USDT.rawValue {
                    stateObject.trc20UsdtTransfersQuery.refetch(request: account.address ?? "")
                }
            default: return
            }
        }
    }
}
