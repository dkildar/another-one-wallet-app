//
//  ManagedAccountRecordFormView.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 20.04.2024.
//

import SwiftUI

let RECORD_TYPES = [
    "incoming": "Incoming",
    "outgoing": "Outgoing"
]

struct ManagedAccountRecordFormView: View {
    @Binding var presetAccount: BankAccount?
    @Binding var presetRecord: ManagedAccountRecord?
    
    @Environment(\.colorScheme) var coloScheme
    @Environment(\.managedObjectContext) var context
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var persistenceController: PersistenceController
    
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
                Section {
                    HStack(alignment: .center) {
                        TextField("Amount", value: $amount, format: .number)
                            .keyboardType(.numberPad)
                            .font(.largeTitle)
                            .foregroundColor(amountColor)
                        
                        Spacer()
                        Text(accountInstance?.getCurrencySymbol() ?? "$")
                            .foregroundStyle(.gray)
                    }
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
                .disabled(presetAccount != nil)
                
                Section("Note") {
                    TextEditor(text: $text)
                        .frame(minHeight: 100)
                }
                
                Section {
                    Button {
                        ManagedAccountHistoryController.shared.createOrUpdate(
                            request: CreateOrUpdateRequest(
                                title: title,
                                text: text,
                                type: type,
                                amount: abs(amount)
                            ),
                            existingRecord: presetRecord,
                            existingAccount: (presetAccount != nil) ? presetAccount : accounts.first(where: { a in
                                return a.name == account
                            })
                        )
                        dismiss()
                    } label: {
                        Text(presetRecord != nil ? "Update" : "Create")
                    }
                    .disabled(title.isEmpty || account == "" || amount == 0.0 || type == "")
                }
            }
            .navigationTitle(presetRecord != nil ? "Update the record" : "Create a record")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onChange(of: amount) {
            calculateColor()
            
            self.type = amount > 0 ? "incoming" : "outgoing"
        }
        .onChange(of: type) {
            calculateColor()
        }
        .onChange(of: coloScheme) {
            calculateColor()
        }
        .onChange(of: account) {
            accountInstance = accounts.first(where: { a in
                return a.name == account
            })
        }
        .onAppear {
            calculateColor()
            
            if let presetAccount = presetAccount {
                account = presetAccount.name!
                accountInstance = presetAccount
            }
            
            if let presetRecord = presetRecord {
                title = presetRecord.title ?? ""
                text = presetRecord.text ?? ""
                type = presetRecord.type ?? ""
                amount = presetRecord.amount
            }
        }
    }
    
    private func calculateColor() {
        amountColor = if amount != 0 {
            if type == "incoming" { .green } else { .red }
        } else { coloScheme == .dark ? .white : .black }
    }
}
