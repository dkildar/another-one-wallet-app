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
    
    @Binding var record: ManagedAccountRecord
    var onDelete: () -> Void
    
    init(record: Binding<ManagedAccountRecord>, onDelete: @escaping () -> Void) {
        self._record = record
        self.onDelete = onDelete
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text((record.type == "incoming" ? "+" : "-") + String(format: "%.2f", record.amount) + (record.account?.getCurrencySymbol() ?? "$"))
                    .foregroundStyle(record.type == "incoming" ? .green : .red)
                
                Spacer()
                if let image = record.image, let uiImage = UIImage(data: image) {
                    Image(systemName: "photo.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 12)
                        .foregroundColor(.gray)
                }
                Text(String(record.created?.formatted(.dateTime.hour().minute()) ?? ""))
                    .font(.caption)
                    .foregroundStyle(.gray)
                    Image(systemName: "chevron.right")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.gray)
                        .frame(width: 10, height: 10)
            }
            
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(record.title ?? "")
                        .lineLimit(2)
                    
                    if let text = record.text {
                        if !text.isEmpty {
                            Text(text)
                                .font(.caption)
                                .foregroundStyle(.gray)
                                .lineLimit(2)
                        }
                    }
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
                ManagedAccountRecordFormView(presetAccount: .constant(account), presetRecord: .constant(record))
            }
        }
    }
}
