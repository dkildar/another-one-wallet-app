//
//  ManagedBankAccountDetailsView.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 13.04.2024.
//

import SwiftUI
import Charts

struct ManagedAccountChartData : Hashable {
    var amount: Double
    var date: Date
}

struct ManagedBankAccountDetailsView: View {
    @Environment(\.managedObjectContext) var context
    @EnvironmentObject var persistenceController: PersistenceController
    
    var account: BankAccount
    
    @State var isCreateRecordPresented = false
    
    init(account: BankAccount) {
        self.account = account
    }
    
    var body: some View {
        VStack {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(String(format: "%.2f", account.balance))
                                .foregroundStyle(.blue)
                                .font(.system(size: 28, weight: .semibold))
                            
                            Spacer()
                            
                            Text(account.getCurrencySymbol())
                                .foregroundStyle(.gray)
                        }
                        Text(account.currency ?? "")
                            .foregroundStyle(.gray)
                            .padding(.bottom, 16)
                        
                        ManagedAccountChartView(account: account)
                    }
                }
                .padding(.vertical, 8)
                
                Section {
                    Button {
                        isCreateRecordPresented.toggle()
                    } label: {
                        Label("Create a record", systemImage: "plus.app")
                    }
                }
                
                ManagedAccountHistoryView(account: account)
            }
        }
        .sheet(isPresented: $isCreateRecordPresented) {
            ManagedAccountRecordFormView(bankAccount: account)
        }
    }
}
