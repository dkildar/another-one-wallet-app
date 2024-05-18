//
//  LinkedCryptoAccountView.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 11.04.2024.
//

import SwiftUI
import SFSymbolsPicker

struct LinkedCryptoAccountFormView: View {
    @EnvironmentObject var cryptoAccountController: CryptoAccountsController
    @EnvironmentObject var persistenceController: PersistenceController
    @Environment(\.dismiss) var dismiss
    
    @Binding var presetAccount: BankAccount?
    
    @State var address: String = ""
    @State var network: AppCurrency.CryptoNetwork = .TRC20
    @State var networks = AppCurrency.CryptoNetwork.allCases
    
    var body: some View {
        BasicAccountCreateFormView(type: .LinkedCrypto, presetAccount: $presetAccount, submit: { account in
            account.address = address
            account.cryptoNetwork = network.rawValue
            
            persistenceController.save(affectedItems: [account])
            cryptoAccountController.loadAccounts()
            
            dismiss()
        }) {
            TextField("Crypto address", text: $address)
                .disabled(presetAccount != nil)
            Picker(selection: $network, label: Text("Network")) {
                ForEach(Array(networks), id: \.hashValue) { network in
                    Text(network.rawValue).tag(network)
                }
            }
            .disabled(presetAccount != nil)
        }
        .onAppear {
            if let presetAccount = presetAccount {
                address = presetAccount.address ?? ""
                network = AppCurrency.CryptoNetwork(rawValue: presetAccount.cryptoNetwork ?? "") ?? .TRC20
            }
        }
    }
}
