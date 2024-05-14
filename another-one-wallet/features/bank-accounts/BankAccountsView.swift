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
    @EnvironmentObject var persistenceController: PersistenceController
    
    @FetchRequest(sortDescriptors: [], animation: .easeIn) var accounts: FetchedResults<BankAccount>
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(accounts.filter({ account in
                    return BankAccountType.init(rawValue: account.type) == .LinkedCrypto
                }), id: \.self) { account in
                    Section {
                        CryptoAccountItemView(account: .constant(account))
                    }
                    .padding(.vertical, 8)
                    .id(persistenceController.sessionID)
                }
                
                Section("Managing accounts") {
                    ForEach(accounts.filter({ account in
                        return BankAccountType.init(rawValue: account.type) == .Managing
                    }), id: \.self) {account in
                        ManagedAccountItemView(account: .constant(account))
                            .background {
                                NavigationLink("", destination: ManagedBankAccountDetailsView(account: .constant(account))
                                    .navigationTitle(account.name ?? "")
                                )
                                .opacity(0)
                            }
                        
                    }
                    .id(persistenceController.sessionID)
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
