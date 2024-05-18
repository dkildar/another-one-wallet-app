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
    
    @Binding var presetAccount: BankAccount?
    
    @State var name = ""
    @State var icon = "plus"
    @State var isSymbolPickerShow = false
    
    @ViewBuilder let content: Content
    
    var submit: (_ account: BankAccount) -> Void
    
    var type: BankAccountType
    
    init(type: BankAccountType, presetAccount: Binding<BankAccount?>, submit: @escaping (_ account: BankAccount) -> Void, @ViewBuilder content: () -> Content) {
        self.type = type
        self._presetAccount = presetAccount
        self.submit = submit
        self.content = content()
    }
    
    var body: some View {
        List {
            Section("Account information") {
                TextField("Name", text: $name)
                Button {
                    isSymbolPickerShow.toggle()
                } label: {
                    HStack {
                        Image(systemName: icon)
                        Text("Pick an icon")
                    }
                }
            }
            
            Section {
                content
            }
            
            Section {
                Button(presetAccount != nil ? "Edit" : "Create") {
                    let account = presetAccount ?? BankAccount(context: managedObjectContext)
                    account.id = UUID.init()
                    account.name = name
                    account.icon = icon
                    account.type = type.rawValue
                    
                    submit(account)
                }
                .disabled(name.isEmpty)
            }
        }
        .onAppear {
            if let presetAccount = presetAccount {
                name = presetAccount.name ?? ""
                icon = presetAccount.icon ?? "plus"
            }
        }
        .sheet(isPresented: $isSymbolPickerShow, content: {
            SymbolsPicker(selection: $icon, title: "Pick a symbol", autoDismiss: true)
        })
    }
}
