//
//  ManagedAccountHistoryModel.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 1.05.2024.
//

import SwiftUI
import CoreData

class ManagedAccountHistoryModel: ObservableObject {
    @Published var recordsList: [ManagedAccountRecord] = []
    @Published var records: Array<(Date, [ManagedAccountRecord])> = []
    
    var context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func fetchRecords(account: BankAccount) {
        let fetchRequest = NSFetchRequest<ManagedAccountRecord>(entityName: "ManagedAccountRecord")
        fetchRequest.predicate = NSPredicate(format: "account.id=%@", account.id?.uuidString ?? "")
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \ManagedAccountRecord.created, ascending: false)]
        do {
            recordsList = try context.fetch(fetchRequest)
            records = getAggregatedRecords(recordsList: recordsList)
        } catch {
            print("Fetch failed")
        }
    }
    
    private func getAggregatedRecords(recordsList: [ManagedAccountRecord]) -> Array<(Date, [ManagedAccountRecord])> {
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
