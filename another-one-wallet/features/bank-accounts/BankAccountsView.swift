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
                NavigationLink {
                    BankAccountDetailsView(account: .constant(account))
                        .navigationTitle(account.name ?? "")
                } label: {
                    HStack(alignment: .center) {
                        ListIconView(string: account.icon ?? "")
                            .padding(.trailing, 4)
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text(account.name ?? "")
                                Text(account.getCurrency().currency.identifier)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            Text(String(account.balance))
                                .font(.caption)
                                .foregroundStyle(Color.blue)
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    CreateBankAccountView()
                }
            }
            .navigationTitle("Bank accounts")
        }
    }
}

#Preview {
    BankAccountsView()
}
