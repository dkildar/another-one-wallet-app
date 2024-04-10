//
//  CreateBankAccountView.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 9.04.2024.
//

import SwiftUI
import CoreData

struct CreateBankAccountView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State var showSheet = false
    @State var name = ""
    @State var currency = Currencies.USD
    
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
                    Text("USD").tag(Currencies.USD)
                    Text("RUB").tag(Currencies.USD)
                }
            }
            .navigationTitle("Add an account")
            
            Button("Submit") {
                let account = BankAccount(context: managedObjectContext)
                account.id = UUID.init()
                account.name = "Name test"
                account.currency = currency.rawValue
                account.address = ""
                do {
                    try managedObjectContext.save()
                } catch {
                    print(error)
                }
                showSheet.toggle()
            }
        }
    }
}

#Preview {
    CreateBankAccountView()
}
