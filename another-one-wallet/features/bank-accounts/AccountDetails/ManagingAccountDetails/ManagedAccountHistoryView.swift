//
//  ManagedAccountHistoryView.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 23.04.2024.
//

import SwiftUI

struct ManagedAccountHistoryView: View {
    @Environment(\.managedObjectContext) var context
    @EnvironmentObject var model: ManagedAccountHistoryModel
    
    @Binding var account: BankAccount
    
    init(account: Binding<BankAccount>) {
        self._account = account
    }
    
    var body: some View {
        ForEach(model.records, id: \.0) { (date, recordsList) in
            Section(header: Text(date.formatted(.dateTime.day().month().year()))) {
                ForEach(recordsList, id: \.self) { record in
                    HistoryRecordItemView(record: .constant(record)) {
                        account.balance -= record.getSignedAmount()
                    }
                    .background {
                        NavigationLink(
                            "",
                            destination: ManagedAccountHistoryDetailsView(record: .constant(record))
                                .navigationTitle(record.title ?? "Record"))
                        .opacity(0)
                    }
                }
            }
        }
    }
}
