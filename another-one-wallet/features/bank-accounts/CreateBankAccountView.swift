//
//  CreateBankAccountView.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 9.04.2024.
//

import SwiftUI
import CoreData
import SFSymbolsPicker

struct CreateBankAccountView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State var showSheet = false
    @State var name = ""
    @State var currency = Currencies.USD
    @State var icon = "plus"
    @State var isSymbolPickerShow = false
    
    var body: some View {
        Button(action: {
            showSheet.toggle()
        }) {
            Image(systemName: "plus.circle")
        }
        .sheet(isPresented: $showSheet) {
            List {
                TextField("Name", text: $name)
                Picker(selection: $currency, label: Text("Currency")) {
                    ForEach(Array(CURRENCIES_MAP.keys), id: \.rawValue) { currency in
                        Text(CURRENCIES_MAP[currency] ?? "").tag(currency)
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
                
                Button("Create") {
                    let account = BankAccount(context: managedObjectContext)
                    account.id = UUID.init()
                    account.name = name
                    account.currency = currency.rawValue
                    account.icon = icon
                    account.address = ""
                    do {
                        try managedObjectContext.save()
                    } catch {
                        print(error)
                    }
                    showSheet.toggle()
                }
                .disabled(name.isEmpty)
            }
            
            .sheet(isPresented: $isSymbolPickerShow, content: {
                SymbolsPicker(selection: $icon, title: "Pick a symbol", autoDismiss: true)
            })
        }
    }
}

#Preview {
    CreateBankAccountView()
}
