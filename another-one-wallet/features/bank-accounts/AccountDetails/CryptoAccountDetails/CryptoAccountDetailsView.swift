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
    @StateObject var stateObject = CryptoAccountDetailsViewModel()
    
    @Binding var account: BankAccount
    @Binding var token: CryptoToken
    
    @ViewBuilder
    var exchangeRate: some View {
        let oneUsdPrice = (Double(token.usdBalance ?? "0.0") ?? 0.0) / (Double(token.balance ?? "0.0") ?? 0.0)
        
        let text = BankAccount.getNumberFormatter().string(from: oneUsdPrice * currenciesWatcherController.rateRelatedToUsd as NSNumber)!
        
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
                Text("≈ " + BankAccount.getNumberFormatter().string(from: Double(token.usdBalance ?? "0.0") as! NSNumber)!)
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
