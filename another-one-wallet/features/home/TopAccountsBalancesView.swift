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
    
    var usdTotal: Double {
        get {
            return Double(accounts.reduce(0.0, { partialResult, account in
                return partialResult + account.getUsdBalance()
            }))
        }
    }
    
    var total: Double {
        get {
            if (currenciesWatcherController.fetchedRates) {
                return currenciesWatcherController.rateRelatedToUsd * Double(usdTotal)
            }
            return 0
        }
    }
    
    var body: some View {
        ListCardView(
            title: .constant("Total funds"),
            systemIconName: .constant("list.bullet.clipboard"),
            accentColor: .constant(.blue)) {
                VStack (alignment: .leading){
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(BankAccount.getNumberFormatter().string(from: total as NSNumber)!)")
                            .font(.system(size: 32))
                            .contentTransition(.numericText())
                            .monospacedDigit()
                            .transaction { t in
                                t.animation = .default
                            }
                        if currenciesWatcherController.currency != .USD {
                            Text("\(BankAccount.getNumberFormatter(currency: .USD).string(from: usdTotal as NSNumber)!)")
                                .font(.caption)
                                .foregroundStyle(.gray)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                }
            } action: {
            }
    }
}
