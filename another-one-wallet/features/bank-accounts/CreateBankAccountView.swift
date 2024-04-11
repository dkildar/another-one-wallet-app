//
//  CreateBankAccountView.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 9.04.2024.
//

import SwiftUI

struct CreateBankAccountView: View {
    @State var showSheet = false
    
    var body: some View {
        Button(action: {
            showSheet.toggle()
        }) {
            Image(systemName: "plus.circle")
        }
        .sheet(isPresented: $showSheet) {
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
            }
        }
    }
}

#Preview {
    CreateBankAccountView()
}
