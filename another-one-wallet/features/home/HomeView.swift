//
//  HomeView.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 9.04.2024.
//

import SwiftUI

struct HomeView: View {
    @FetchRequest(sortDescriptors: [], animation: .easeIn) var accounts: FetchedResults<BankAccount>
    
    var body: some View {
        NavigationStack {
            List {
                TopAccountsBalancesView()
                ExchangeRatesWidgetView()
            }
            .navigationTitle("Home")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    ToolbarPlusMenuView()
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
