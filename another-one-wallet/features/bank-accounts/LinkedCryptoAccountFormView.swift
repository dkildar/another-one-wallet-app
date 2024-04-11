//
//  LinkedCryptoAccountView.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 11.04.2024.
//

import SwiftUI
import SFSymbolsPicker

struct LinkedCryptoAccountFormView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.dismiss) var dismiss
    
    @State var address: String = ""
    
    var body: some View {
        BasicAccountCreateFormView(type: .LinkedCrypto, submit: { account in
            account.address = address
            
            do {
                try managedObjectContext.save()
            } catch {
                print(error)
            }
            dismiss()
        }) {
            TextField("Crypto address", text: $address)
        }
    }
}

#Preview {
    LinkedCryptoAccountFormView()
}
