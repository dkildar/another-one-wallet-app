//
//  ManagedAccountItemView.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 11.04.2024.
//

import SwiftUI

struct ManagedAccountItemView: View {
    @EnvironmentObject var currenciesWatcherController: CurrenciesWatcherController
    
    @Binding var account: BankAccount
    
    var totalInAccountCurrency: String {
        get {
            return String(format: "%.2f", account.balance) + account.getCurrencySymbol()
        }
    }
    var total: String {
        get {
            let totalInAccountCurrency = account.balance
            let accountCurrency = RealCurrency.init(rawValue: account.currency ?? "USD")
            let conversionRateFromAppCurrencyToUsd = currenciesWatcherController.rateRelatedToUsd
            let conversionRateFromAccountToUsd = currenciesWatcherController.allRates[account.currency ?? "USD"] ?? 1
            
            return String(format: "%.2f", totalInAccountCurrency * conversionRateFromAppCurrencyToUsd * 1/conversionRateFromAccountToUsd)
        }
    }
    
    var body: some View {
        let isSameCurrency = account.currency == currenciesWatcherController.currency.rawValue
        
        HStack(alignment: .center) {
            ListIconView(string: account.icon ?? "")
                .padding(.trailing, 4)
            
            HStack {
                VStack(alignment: .leading) {
                    Text(account.name ?? "")
                    Text(account.getCurrency().currency.identifier)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
        
                VStack(alignment: .trailing) {
                    HStack(alignment: .center) {
                        Text(isSameCurrency ? totalInAccountCurrency : (total + RealCurrency.getCurrencySymbol(currency: currenciesWatcherController.currency)))
                            .font(.caption)
                            .foregroundStyle(Color.blue)
                        
                        Image(systemName: "chevron.right")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.gray)
                            .frame(width: 10, height: 10)
                    }
                    if !isSameCurrency {
                        Text(totalInAccountCurrency)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
    }
}
