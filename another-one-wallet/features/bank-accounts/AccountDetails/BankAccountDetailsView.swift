//
//  BankAccountDetailsView.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 11.04.2024.
//

import SwiftUI

struct BankAccountDetailsView: View {
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.dismiss) var dismiss

    var account: BankAccount
    var token: CryptoToken?
    
    @State var isConfirmationPresented = false
    
    init(account: BankAccount) {
        self.account = account
    }
    
    init(account: BankAccount, token: CryptoToken) {
        self.account = account
        self.token = token
    }
    
    var body: some View {
        VStack {
            VStack {
                if BankAccountType.init(rawValue: account.type) == .Managing {
                    ManagedBankAccountDetailsView(account: account)
                } else if let token = token {
                    CryptoAccountDetailsView(account: account, token: token)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button {
                            isConfirmationPresented.toggle()
                        } label: {
                            Label("Delete account", systemImage: "trash")
                        }
                        .foregroundStyle(.red)
                    } label: {
                        Image(systemName: "gear.circle")
                    }
                }
            }
        }
        .confirmationDialog("Are you sure?", isPresented: $isConfirmationPresented) {
            Button("Yes, delete", role: .destructive) {
                PersistenceController.shared.delete(item: account)
                dismiss()
            }
        }
    }
}
