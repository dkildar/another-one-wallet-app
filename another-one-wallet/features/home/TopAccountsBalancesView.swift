//
//  TopAccountsBalancesView.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 13.04.2024.
//

import SwiftUI
import Charts

struct TopAccountsBalancesView: View {
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \BankAccount.balance, ascending: false)]) var accounts: FetchedResults<BankAccount>
    
    @State var total = 0
    
    var body: some View {
        Section {
            VStack(alignment: .leading, spacing: 4) {
                Text("Total funds")
                    .foregroundStyle(Color.gray)
                Text("\(total)$")
                    .font(.largeTitle)
            }
            .padding(.bottom, 4)
            Chart(accounts) { account in
                BarMark(
                    x: .value("Account", account.balance)
                )
                .foregroundStyle(by: .value("Account", account.name ?? ""))
                .annotation(position: .overlay, alignment: .center, spacing: 0) {
                    Text(verbatim: String(format: "%.0f", account.balance) + (BankAccountType.init(rawValue: account.type) == .Managing ? account.getCurrencySymbol() : "$"))
                        .font(.caption)
                        .foregroundStyle(Color.white)
                }
            }
            .chartXScale(domain: 0...total)
            .chartXAxis {
                AxisMarks(position: .bottom) { _ in
                    AxisValueLabel().foregroundStyle(.clear)
                }
            }
        }
        .padding(.vertical, 8)
        .task(id: accounts.count) {
            // todo: convert to single currency
            total = Int(accounts.reduce(0, { partialResult, account in
                partialResult + (Int(String(format: "%.0f", account.balance)) ?? 0)
            }))
        }
    }
}

#Preview {
    TopAccountsBalancesView()
}
