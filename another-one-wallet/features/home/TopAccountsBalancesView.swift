//
//  TopAccountsBalancesView.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 13.04.2024.
//

import SwiftUI
import Charts

struct TopAccountsBalancesView: View {
    @EnvironmentObject var currenciesWatcherController: CurrenciesWatcherController
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \BankAccount.balance, ascending: false)]) var accounts: FetchedResults<BankAccount>
    
    @State var total = 0
    @State var usdTotal = 0
    
    var body: some View {
        ListCardView(
            title: .constant("Total funds"),
            systemIconName: .constant("list.bullet.clipboard"),
            accentColor: .constant(.blue)) {
                VStack (alignment: .leading){
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(total)\(RealCurrency.getCurrencySymbol(currency: currenciesWatcherController.currency))")
                            .font(.system(size: 32))
                        if currenciesWatcherController.currency != .USD {
                            Text("\(usdTotal)\(RealCurrency.getCurrencySymbol(currency: .USD))")
                                .font(.caption)
                                .foregroundStyle(.gray)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                }
            } action: {
            }
            .task(id: accounts.count) {
                total = Int(accounts.reduce(0, { partialResult, account in
                    partialResult + (Int(String(format: "%.0f", account.balance)) ?? 0)
                }))
            }
            .task(id: currenciesWatcherController.rateRelatedToUsd) {
                usdTotal = Int(accounts.reduce(0.0, { partialResult, account in
                    let nextBalance = Double(String(format: "%.0f", account.balance)) ?? 0.0
                    
                    return partialResult + nextBalance
                }))
                total = Int(currenciesWatcherController.rateRelatedToUsd * Double(usdTotal))
            }
    }
}
