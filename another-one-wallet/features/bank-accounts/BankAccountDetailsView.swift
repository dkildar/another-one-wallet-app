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
            List {
                Button {
                    isConfirmationPresented.toggle()
                } label: {
                    HStack {
                        Image(systemName: "trash")
                        Text("Delete account")
                    }
                }
                .foregroundColor(.red)
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
