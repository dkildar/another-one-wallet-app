//
//  BankAccountsView.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 9.04.2024.
//

import SwiftUI
import CoreData

struct BankAccountsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [], animation: .easeIn) var accounts: FetchedResults<BankAccount>
    
    var body: some View {
        NavigationStack {
            List(accounts, id: \.id) { account in
                VStack {
                    NavigationLink {
                        BankAccountDetailsView(account: .constant(account))
                            .navigationTitle(account.name ?? "")
                    } label: {
                        if (account.getAccountType() == .Managing) {
                            ManagedAccountItemView(account: account)
                        } else if (account.getAccountType() == .LinkedCrypto) {
                            CryptoAccountItemView(account: account)
                        }
                    }
                }.padding(.vertical, 8)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    ToolbarPlusMenuView()
                }
            }
            .navigationTitle("Bank accounts")
        }
    }
}

#Preview {
    BankAccountsView()
}
