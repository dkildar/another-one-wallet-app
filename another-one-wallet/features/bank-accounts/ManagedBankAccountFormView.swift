//
//  ManagedBankAccountFormView.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 11.04.2024.
//

import SwiftUI

struct ManagedBankAccountFormView: View {
    @EnvironmentObject var persistenceController: PersistenceController
    @Environment(\.dismiss) var dismiss
    
    @Binding var presetAccount: BankAccount?
    
    @State var initialBalance = 0.0
    @State var currency = RealCurrency.USD
    
    var currencies: [RealCurrency] = RealCurrency.allCases
    
    var body: some View {
        BasicAccountCreateFormView(type: .Managing, presetAccount: $presetAccount, submit: { account in
            account.balance = initialBalance
            account.currency = currency.rawValue
            
            persistenceController.save(affectedItems: [account])
            
            dismiss()
        }) {
            Picker(selection: $currency, label: Text("Currency")) {
                ForEach(Array(currencies), id: \.hashValue) { currency in
                    Text(currency.rawValue).tag(currency)
                }
            }
            .disabled(presetAccount != nil)
            TextField("Initial balance", value: $initialBalance, format: .number)
                .keyboardType(.numbersAndPunctuation)
                .disabled(presetAccount != nil)
        }
        .onAppear {
            if let presetAccount = presetAccount {
                initialBalance = presetAccount.balance
                currency = RealCurrency(rawValue: presetAccount.currency ?? "USD") ?? .USD
            }
        }
    }
}
