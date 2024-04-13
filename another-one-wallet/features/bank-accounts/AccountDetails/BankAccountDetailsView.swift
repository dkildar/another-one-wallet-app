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

    @Binding var account: BankAccount
    
    @State var isConfirmationPresented = false
    
    var body: some View {
        VStack {
            VStack {
                if BankAccountType.init(rawValue: account.type) == .Managing {
                    ManagedBankAccountDetailsView(account: account)
                } else {
                    EmptyView()
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button {
                            isConfirmationPresented.toggle()
                        } label: {
                            Label("Delete account", image: "trash")
                                .foregroundStyle(.red)
                        }
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

#Preview {
    BankAccountDetailsView(account: .constant(BankAccount()))
}
