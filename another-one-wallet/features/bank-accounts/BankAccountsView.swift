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
    @State var selectedSection = 0
    
    var managingAccounts: [BankAccount] {
        get {
            return accounts.filter({ account in
                return BankAccountType.init(rawValue: account.type) == .Managing
            })
        }
    }
    
    var cryptoAccounts: [BankAccount] {
        get {
            return accounts.filter({ account in
                return BankAccountType.init(rawValue: account.type) == .LinkedCrypto
            })
        }
    }
    
    @ViewBuilder
    var managingAccountsView: some View {
        ForEach(managingAccounts, id: \.self) {account in
            ManagedAccountItemView(account: .constant(account))
                .background {
                    NavigationLink("", destination: ManagedBankAccountDetailsView(account: .constant(account))
                        .navigationTitle(account.name ?? "")
                    )
                    .opacity(0)
                }
        }
    }
    
    @ViewBuilder
    var cryptoAccountsView: some View {
        ForEach(cryptoAccounts, id: \.self) { account in
            CryptoAccountItemView(account: .constant(account))
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                if selectedSection == 0 && !cryptoAccounts.isEmpty {
                    Section("Crypto accounts") {
                        cryptoAccountsView
                    }
                } else if selectedSection == 2 {
                    cryptoAccountsView
                }
                
                if accounts.isEmpty {
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
                } else if selectedSection == 0 && !managingAccounts.isEmpty {
                    Section("Managing accounts") {
                        managingAccountsView
                    }
                    .padding(.vertical, 8)
                } else if selectedSection == 1 {
                        managingAccountsView
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Picker(selection: $selectedSection.animation(), label: Text(""), content: {
                        Text("All").tag(0)
                        Text("Managing").tag(1)
                        Text("Crypto").tag(2)
                    }).pickerStyle(SegmentedPickerStyle())
                }
                ToolbarItem(placement: .topBarTrailing) {
                    ToolbarPlusMenuView()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $isAccountCreatingPresented) {
                CreateBankAccountView()
            }
        }
    }
}
