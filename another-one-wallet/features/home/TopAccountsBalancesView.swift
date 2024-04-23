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
        Section {
            VStack(alignment: .leading, spacing: 4) {
                Text("Total funds")
                    .foregroundStyle(Color.gray)
                Text("\(total)\(RealCurrency.getCurrencySymbol(currency: currenciesWatcherController.currency))")
                    .font(.largeTitle)
                if currenciesWatcherController.currency != .USD {
                    Text("\(usdTotal)\(RealCurrency.getCurrencySymbol(currency: .USD))")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
            }
            .padding(.bottom, 4)
            Chart(accounts) { account in
                BarMark(
                    x: .value("Value", account.balance),
                    y: .value("Account", account.name ?? "")
                )
                .foregroundStyle(by: .value("Account", account.name ?? ""))
                .annotation(position: .overlay, alignment: .center, spacing: 0) {
                    Text(verbatim: String(format: "%.0f", account.balance) + (BankAccountType.init(rawValue: account.type) == .Managing ? account.getCurrencySymbol() : "$"))
                        .font(.caption)
                        .foregroundStyle(Color.white)
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 300)
//            .chartXScale(domain: 0...total)
        }
        .padding(.vertical, 8)
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

#Preview {
    TopAccountsBalancesView()
}
