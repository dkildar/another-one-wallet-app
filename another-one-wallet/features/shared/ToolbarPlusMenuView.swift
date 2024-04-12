//
//  ToolbarPlusMenuView.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 12.04.2024.
//

import SwiftUI

struct ToolbarPlusMenuView: View {
    @State var showCreateAccountSheet = false
    @State var showCreateRecordSheet = false
    
    var body: some View {
        Menu {
            Button {
                showCreateRecordSheet.toggle()
            } label: {
                Label("Create a record", systemImage: "plus.app")
            }
            
            Button {
                showCreateAccountSheet.toggle()
            } label: {
                Label("Create an account", systemImage: "plus.square.on.square")
            }
        } label: {
            Image(systemName: "plus.circle")
        }
        .sheet(isPresented: $showCreateAccountSheet) {
            CreateBankAccountView()
        }
        .sheet(isPresented: $showCreateRecordSheet) {
            CreateAccountRecordView()
        }
    }
}

#Preview {
    ToolbarPlusMenuView()
}
