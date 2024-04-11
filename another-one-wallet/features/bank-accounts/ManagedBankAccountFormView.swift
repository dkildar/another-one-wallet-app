//
//  ManagedBankAccountFormView.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 11.04.2024.
//

import SwiftUI

struct ManagedBankAccountFormView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.dismiss) var dismiss
    
    @State var initialBalance = 0.0
    @State var currency = AppCurrency(currency: .USD)
    
    var currencies: [AppCurrency] = AppCurrency.Currencies.allCases.map({ currency in
        AppCurrency(currency: currency)
    })
    
    var body: some View {
        BasicAccountCreateFormView(type: .Managing, submit: { account in
            account.balance = initialBalance
            account.currency = currency.currency.identifier
            
            do {
                try managedObjectContext.save()
            } catch {
                print(error)
            }
            dismiss()
        }) {
            Picker(selection: $currency, label: Text("Currency")) {
                ForEach(Array(currencies), id: \.hashValue) { currency in
                    Text(currency.currency.identifier).tag(currency)
                }
            }
            TextField("Initial balance", value: $initialBalance, format: .number)
                .keyboardType(.numbersAndPunctuation)
        }
    }
}

#Preview {
    ManagedBankAccountFormView()
}
