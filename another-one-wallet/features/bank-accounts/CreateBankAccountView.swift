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
                    ManagedBankAccountFormView()
                        .navigationTitle("Managing bank account")
                } label: {
                    Text("Managing bank account")
                }
                
                NavigationLink {
                    LinkedCryptoAccountFormView()
                        .navigationTitle("Linked crypto account")
                } label: {
                    Text("Linked crypto account")
                }
            }
            .navigationTitle("Create an account")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    CreateBankAccountView()
}
