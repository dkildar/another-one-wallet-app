//
//  HistoryRecordItemView.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 13.04.2024.
//

import SwiftUI

struct HistoryRecordItemView: View {
    var record: ManagedAccountRecord
    
    init(record: ManagedAccountRecord) {
        self.record = record
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text((record.type == "incoming" ? "+" : "-") + String(format: "%.2f", record.amount) + (record.account?.getCurrencySymbol() ?? "$"))
                    .foregroundStyle(record.type == "incoming" ? .green : .red)
                
                Spacer()
                
                // TODO Сделать группы истории листа по дням
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
    }
}
