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
    @State var isAccountCreatingPresented = false
    
    var managingAccounts: [BankAccount] {
        get {
            return accounts.filter({ account in
                return BankAccountType.init(rawValue: account.type) == .Managing
            })
        }
    }
    
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
                
                if managingAccounts.isEmpty {
                    VStack(alignment: .center) {
                        Text("You don't have any account yet")
                            .foregroundStyle(.gray)
                            .padding(.bottom)
                        
                        Button {
                            isAccountCreatingPresented.toggle()
                        } label: {
                            Text("Create an account")
                        }
                        .buttonStyle(BorderedProminentButtonStyle())
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 32)
                    .listRowBackground(Color.clear)
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                } else {
                    Section("Managing accounts") {
                        ForEach(managingAccounts, id: \.self) {account in
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
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    ToolbarPlusMenuView()
                }
            }
            .sheet(isPresented: $isAccountCreatingPresented) {
                CreateBankAccountView()
            }
            .navigationTitle("Bank accounts")
        }
    }
}
