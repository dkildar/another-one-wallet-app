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
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var persistenceController: PersistenceController

    @Binding var account: BankAccount
    
    @StateObject var model = ManagedAccountHistoryModel(context: PersistenceController.shared.container.viewContext)
    @State var isConfirmationPresented = false
    @State var isCreateRecordPresented = false
    
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
                        
                        ManagedAccountChartView(account: $account)
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
                
                ManagedAccountHistoryView(account: $account)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button {
                        isConfirmationPresented.toggle()
                    } label: {
                        Label("Delete account", systemImage: "trash")
                    }
                    .foregroundStyle(.red)
                } label: {
                    Image(systemName: "gear.circle")
                }
            }
        }
        .confirmationDialog("Are you sure?", isPresented: $isConfirmationPresented) {
            Button("Yes, delete", role: .destructive) {
                persistenceController.delete(item: account)
                dismiss()
            }
        }
        .sheet(isPresented: $isCreateRecordPresented) {
            ManagedAccountRecordFormView(presetAccount: .constant(account), presetRecord: .constant(nil))
        }
        .environmentObject(model)
        .onAppear {
            model.fetchRecords(account: account)
        }
    }
}
