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
    @State var icon = "plus"
    @State var isSymbolPickerShow = false
    
    @ViewBuilder let content: Content
    
    var submit: (_ account: BankAccount) -> Void
    
    var type: BankAccountType
    
    init(type: BankAccountType, submit: @escaping (_ account: BankAccount) -> Void, @ViewBuilder content: () -> Content) {
        self.type = type
        self.submit = submit
        self.content = content()
    }
    
    var body: some View {
        List {
            TextField("Name", text: $name)
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
                account.icon = icon
                account.type = type.rawValue
                
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
