//
//  HistoryRecordItemView.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 13.04.2024.
//

import SwiftUI

struct HistoryRecordItemView: View {
    @EnvironmentObject var persistentController: PersistenceController
    
    @State var isEditPresented = false
    
    var record: ManagedAccountRecord
    var onDelete: () -> Void
    
    init(record: ManagedAccountRecord, onDelete: @escaping () -> Void) {
        self.record = record
        self.onDelete = onDelete
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text((record.type == "incoming" ? "+" : "-") + String(format: "%.2f", record.amount) + (record.account?.getCurrencySymbol() ?? "$"))
                    .foregroundStyle(record.type == "incoming" ? .green : .red)
                
                Spacer()
                
                // TODO 
                //      добавить возможность прикрепить фото
                Text(String(record.created?.formatted(.dateTime.hour().minute()) ?? ""))
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            Text(record.title ?? "")
            if let text = record.text {
                if !text.isEmpty {
                    Text(text)
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
            }
        }
        .padding(.vertical, 4)
        .swipeActions(edge: .leading) {
            Button {
                isEditPresented.toggle()
            } label: {
                Label("Edit", systemImage: "pencil")
            }
            .tint(.gray)
        }
        .swipeActions(edge: .trailing) {
            Button {
                onDelete()
                persistentController.delete(item: record)
            } label: {
                Label("Remove", systemImage: "trash")
            }
            .tint(.red)
        }
        .sheet(isPresented: $isEditPresented) {
            if let account = record.account {
                ManagedAccountRecordFormView(bankAccount: account, record: record)
            }
        }
    }
}
