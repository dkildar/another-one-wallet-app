//
//  ManagedAccountHistoryView.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 23.04.2024.
//

import SwiftUI

struct ManagedAccountHistoryView: View {
    @Environment(\.managedObjectContext) var context
    @EnvironmentObject var persistenceController: PersistenceController
    
    @FetchRequest var recordsList: FetchedResults<ManagedAccountRecord>
    
    @Binding var account: BankAccount
    
    init(account: Binding<BankAccount>) {
        self._account = account
        
        let predicate = if let id = account.id?.uuidString {
            NSPredicate(format: "account.id=%@", id)
        } else {
            NSPredicate(format: "account.id=%@", UUID().uuidString)
        }
        
        _recordsList = FetchRequest(
            sortDescriptors: [
                NSSortDescriptor(keyPath: \ManagedAccountRecord.created, ascending: false)
            ],
            predicate: predicate
        )
    }
    
    var records: Array<(Date, [ManagedAccountRecord])> {
        get {
            var recordsMap: [Date: [ManagedAccountRecord]] = [:]
            for record in recordsList {
                guard let recordDate = record.created else {
                    continue
                }
                let date = recordDate.clearTime()!
                if recordsMap[date] == nil {
                    recordsMap[date] = []
                }
                recordsMap[date]?.append(record)
            }
            
            return recordsMap.sorted(by: { $0.0 > $1.0 })
        }
    }
    
    var body: some View {
        ForEach(records, id: \.0) { (date, recordsList) in
            Section(header: Text(date.formatted(.dateTime.day().month().year()))) {
                ForEach(recordsList, id: \.self) { record in
                    HistoryRecordItemView(record: .constant(record)) {
                        account.balance -= record.getSignedAmount()
                    }
                }
            }
        }
        .id(persistenceController.sessionID)
    }
}
