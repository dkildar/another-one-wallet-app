//
//  BasicAccountCreateFormView.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 11.04.2024.
//

import SwiftUI
import SFSymbolsPicker

struct BasicAccountCreateFormView<Content: View>: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State var name = ""
    @State var currency = AppCurrency(currency: .USD)
    @State var icon = "plus"
    @State var isSymbolPickerShow = false
    @State var initialBalance = 0.0
    
    @ViewBuilder let content: Content
    
    var submit: (_ account: BankAccount) -> Void
    
    var type: BankAccountType
    var currencies: [AppCurrency] = []
    
    init(type: BankAccountType, submit: @escaping (_ account: BankAccount) -> Void, @ViewBuilder content: () -> Content) {
        self.type = type
        self.submit = submit
        self.content = content()
        
        if (type == .Managing) {
            currency = AppCurrency(currency: .USD)
            currencies = AppCurrency.Currencies.allCases.map({ currency in
                AppCurrency(currency: currency)
            })
        } else if (type == .LinkedCrypto) {
            currency = AppCurrency(currency: .USDT)
            currencies = AppCurrency.CryptoCurrencies.allCases.map({ currency in
                AppCurrency(currency: currency)
            })
        }
    }
    
    var body: some View {
        List {
            TextField("Name", text: $name)
            TextField("Initial balance", value: $initialBalance, format: .number)
                .keyboardType(.numbersAndPunctuation)
            Picker(selection: $currency, label: Text("Currency")) {
                ForEach(Array(currencies), id: \.hashValue) { currency in
                    Text(currency.currency.identifier).tag(currency)
                }
            }
            Button {
                isSymbolPickerShow.toggle()
            } label: {
                HStack {
                    Image(systemName: icon)
                    Text("Pick an icon")
                }
            }
            
            content
            
            Button("Create") {
                let account = BankAccount(context: managedObjectContext)
                account.id = UUID.init()
                account.name = name
                account.currency = currency.currency.identifier
                account.icon = icon
                account.address = ""
                account.type = type.rawValue
                account.balance = initialBalance
                
                submit(account)
            }
            .disabled(name.isEmpty)
        }
        
        .sheet(isPresented: $isSymbolPickerShow, content: {
            SymbolsPicker(selection: $icon, title: "Pick a symbol", autoDismiss: true)
        })
    }
}

#Preview {
    BasicAccountCreateFormView(type: .Managing, submit: { account in
        
    }) {
    }
}
