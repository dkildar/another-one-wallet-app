//
//  CreateBankAccountView.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 9.04.2024.
//

import SwiftUI

struct CreateBankAccountView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink {
                    ManagedBankAccountFormView(presetAccount: .constant(nil))
                        .navigationTitle("Managing bank account")
                } label: {
                    Label("Managing bank account", systemImage: "list.bullet.rectangle")
                        .padding(.vertical, 8)
                        .foregroundColor(.blue)
                }
                
                NavigationLink {
                    LinkedCryptoAccountFormView(presetAccount: .constant(nil))
                        .navigationTitle("Linked crypto account")
                } label: {
                    Label("Linked crypto account", systemImage: "safari")
                        .padding(.vertical, 8)
                        .foregroundColor(.green)
                }
            }
            .navigationTitle("Create an account")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
