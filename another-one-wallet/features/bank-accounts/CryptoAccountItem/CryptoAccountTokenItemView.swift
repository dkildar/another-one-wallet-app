//
//  CryptoAccountItemView.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 11.04.2024.
//

import SwiftUI
import Combine

struct CryptoAccountItemView: View {
    @EnvironmentObject var currenciesWatcherController: CurrenciesWatcherController
    @Binding var account: BankAccount
    
    var tokens: [CryptoToken] {
        get {
            return (account.tokens?.array as? [CryptoToken]) ?? []
        }
    }
    
    var isSameCurrency: Bool {
        get {
            return account.currency == currenciesWatcherController.currency.rawValue
        }
    }
    
    var total: String {
        get {
            let nextBalance = isSameCurrency ? account.balance : account.getUsdBalance() * currenciesWatcherController.rateRelatedToUsd
            return "\(BankAccount.getNumberFormatter().string(from: nextBalance as NSNumber)!)"
        }
    }
    
    var totalInUsd: String {
        get {
            return "\(BankAccount.getNumberFormatter(currency: RealCurrency(rawValue: account.currency ?? "USD") ?? .USD).string(from: account.getUsdBalance() as NSNumber)!)"
        }
    }
    
    var body: some View {
        Group {
            HStack {
                ListIconView(string: account.icon ?? "", bgColor: .green)
                    .padding(.trailing, 4)
                VStack(alignment: .leading) {
                    Text(account.name ?? "")
                    Text(account.cryptoNetwork ?? "")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text(total)
                        .font(.caption)
                        .foregroundStyle(Color.green)
                    if !isSameCurrency {
                        Text(totalInUsd)
                            .font(.caption)
                            .foregroundStyle(Color.gray)
                    }
                }
            }
            ForEach(tokens, id: \.self) { token in
                NavigationLink {
                    CryptoAccountDetailsView(
                        account: $account,
                        token: .constant(token)
                    )
                        .navigationTitle("\(account.name ?? "") – \(token.name ?? "")")
                } label: {
                    CryptoTokenItemView(account: $account, token: .constant(token))
                }
                .padding(.leading, 48)
            }
        }
    }
}
