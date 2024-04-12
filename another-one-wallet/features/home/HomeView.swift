//
//  HomeView.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 9.04.2024.
//

import SwiftUI

struct HomeView: View {
    @FetchRequest(sortDescriptors: [], animation: .easeIn) var accounts: FetchedResults<BankAccount>
    
    @State var total: Int = 0
    
    var body: some View {
        NavigationStack {
            List {
                
            }
            .navigationTitle("Total funds: \(total)")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    ToolbarPlusMenuView()
                }
            }
        }
        .task(id: accounts.count) {
            // todo: convert to single currency
            total = Int(accounts.reduce(0.0, { partialResult, account in
                partialResult + account.balance
            }))
        }
    }
}

#Preview {
    HomeView()
}
