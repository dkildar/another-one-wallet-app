//
//  CreateAccountRecordView.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 12.04.2024.
//

import SwiftUI

let RECORD_TYPES = [
    "incoming": "Incoming",
    "outgoing": "Outgoing"
]

struct CreateAccountRecordView: View {
    @Environment(\.managedObjectContext) var context
    @Environment(\.dismiss) var dismiss
    @FetchRequest(sortDescriptors: []) var accounts: FetchedResults<BankAccount>
    
    @State var title: String = ""
    @State var text: String = ""
    @State var account: String = ""
    @State var type: String = "incoming"
    @State var amount: Double = 0.0
    @State var amountColor: Color = .black
    @State var accountInstance: BankAccount? = nil
    
    var body: some View {
        NavigationView {
            List {
                HStack(alignment: .top) {
                    if amount != 0 {
                        Text(type == "incoming" ? "+" : "-")
                            .font(.largeTitle)
                            .foregroundColor(amountColor)
                    }
                    TextField("Amount", value: $amount, format: .number)
                        .keyboardType(.numbersAndPunctuation)
                        .font(.largeTitle)
                        .foregroundColor(amountColor)
                        .padding(.bottom)
                    
                    Spacer()
                    Text(accountInstance?.getCurrencySymbol() ?? "$")
                        .foregroundStyle(.gray)
                }
                TextField("Title", text: $title)
                Picker("Type", selection: $type) {
                    ForEach(Array(RECORD_TYPES.keys), id: \.self) { type in
                        Text(RECORD_TYPES[type] ?? "").tag(type)
                    }
                }
                Picker("Account", selection: $account) {
                    Text("Not selected").tag("")
                    ForEach(accounts.filter { account in BankAccountType.init(rawValue: account.type) == .Managing }, id: \.id) { account in
                        Text(account.name ?? "").tag(account.name ?? "")
                    }
                }
                TextEditor(text: $text)
                Button {
                    let record = ManagedAccountRecord(context: context)
                    record.title = title
                    record.text = text
                    record.account = accounts.first(where: { a in
                        return a.name == account
                    })
                    record.type = type
                    record.amount = amount
                    record.created = Date.now
                    
                    record.account?.balance += type == "incoming" ? amount : amount * -1
                    
                    try? context.save()
                    dismiss()
                } label: {
                    Text("Create record")
                }
                .disabled(title.isEmpty || account == "" || amount == 0.0 || type == "")
            }
            .navigationTitle("Create a record")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onChange(of: amount) {
            calculateColor()
        }
        .onChange(of: type) {
            calculateColor()
        }
        .onChange(of: account) {
            accountInstance = accounts.first(where: { a in
                return a.name == account
            })
        }
    }
    
    private func calculateColor() {
        amountColor = if amount != 0 {
            if type == "incoming" { .green } else { .red }
        } else { .black }
    }
}

#Preview {
    CreateAccountRecordView()
}
