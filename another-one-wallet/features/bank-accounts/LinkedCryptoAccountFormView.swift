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
    @State var network: AppCurrency.CryptoNetwork = .TRC20
    @State var networks = AppCurrency.CryptoNetwork.allCases
    
    var body: some View {
        BasicAccountCreateFormView(type: .LinkedCrypto, submit: { account in
            account.address = address
            account.cryptoNetwork = network.rawValue
            
            do {
                try managedObjectContext.save()
            } catch {
                print(error)
            }
            dismiss()
        }) {
            TextField("Crypto address", text: $address)
            Picker(selection: $network, label: Text("Network")) {
                ForEach(Array(networks), id: \.hashValue) { network in
                    Text(network.rawValue).tag(network)
                }
            }
        }
    }
}

#Preview {
    LinkedCryptoAccountFormView()
}
