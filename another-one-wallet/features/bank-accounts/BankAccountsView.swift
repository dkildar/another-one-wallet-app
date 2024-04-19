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
            List {
                ForEach(accounts.filter({ account in
                    return BankAccountType.init(rawValue: account.type) == .LinkedCrypto
                })) { account in
                    Section {
                        CryptoAccountItemView(account: account)
                    }
                    .padding(.vertical, 8)
                }
                
                Section("Managing accounts") {
                    ForEach(accounts.filter({ account in
                        return BankAccountType.init(rawValue: account.type) == .Managing
                    }), id: \.id) {account in
                        NavigationLink {
                            BankAccountDetailsView(account: account)
                                .navigationTitle(account.name ?? "")
                        } label: {
                            ManagedAccountItemView(account: account)
                        }
                    }
                }
                .padding(.vertical, 8)
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
