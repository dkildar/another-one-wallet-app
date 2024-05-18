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
    @EnvironmentObject var currenciesWatcherController: CurrenciesWatcherController
    @StateObject var trc20StateObject = TRC20DetailsStateObject()
    @StateObject var tonStateObject = TONDetailsStateObject()
    
    @Binding var account: BankAccount
    @Binding var token: CryptoToken
    
    @ViewBuilder
    var exchangeRate: some View {
        let text = BankAccount.getNumberFormatter().string(from: token.getUsdRate() * currenciesWatcherController.rateRelatedToUsd as NSNumber)!
        
        Text("1\(token.abbr?.uppercased() ?? "") = \(text)")
            .foregroundStyle(.gray)
            .font(.caption)
            .padding(.top, 8)
    }
    
    @ViewBuilder
    var details: some View {
        Section {
            VStack(alignment: .leading, spacing: 4) {
                exchangeRate
                HStack {
                    Text(String(format: "%.2f", (Double(token.balance ?? "0") ?? 0)))
                        .foregroundStyle(.blue)
                        .font(.system(size: 28, weight: .semibold))
                    
                    Spacer()
                    
                    Text(token.abbr?.uppercased() ?? "")
                        .foregroundStyle(.gray)
                }
                Text(BankAccount.getNumberFormatter().string(from: ((Double(token.usdBalance ?? "0.0") ?? 0.0) * currenciesWatcherController.rateRelatedToUsd) as NSNumber)!)
                    .foregroundStyle(.gray)
                
                SecureAddressView(account: $account)
                    .padding(.top, 16)
            }
        }
        .padding(.vertical, 8)
    }
    
    var body: some View {
        VStack {
            List {
                details
                switch AppCurrency.CryptoNetwork.init(rawValue: account.cryptoNetwork!) {
                case .TRC20:
                    if token.abbr == AppCurrency.CryptoCurrencies.USDT.rawValue {
                        TRC20UsdtTokenDetailsView(
                            stateObject: trc20StateObject, 
                            account: $account,
                            token: $token
                        )
                    }
                case .TON:
                    TONTokenDetailsView(stateObject: tonStateObject, account: $account, token: $token)
                default: EmptyView()
                }
            }
        }
        .onAppear {
            switch AppCurrency.CryptoNetwork.init(rawValue: account.cryptoNetwork!) {
            case .TRC20: 
                if token.abbr == AppCurrency.CryptoCurrencies.USDT.rawValue {
                    trc20StateObject.trc20UsdtTransfersQuery.refetch(request: account.address ?? "")
                }
            case .TON:
                tonStateObject.tonTransfersQuery.refetch(request: account.address ?? "")
            default: return
            }
        }
    }
}
