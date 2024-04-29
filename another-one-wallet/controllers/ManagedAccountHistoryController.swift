//
//  ManagedAccountHistoryController.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 22.04.2024.
//

import Foundation

struct CreateOrUpdateRequest {
    let title: String
    let text: String
    let type: String
    let amount: Double
    let image: Data?
}

struct ManagedAccountHistoryController {
    static let shared = ManagedAccountHistoryController()
    
    func createOrUpdate(request: CreateOrUpdateRequest, existingRecord: ManagedAccountRecord?, existingAccount: BankAccount?) {
        let record = existingRecord ?? ManagedAccountRecord(context: PersistenceController.shared.container.viewContext)
        record.title = request.title
        record.text = request.text
        record.account = existingRecord?.account ?? existingAccount
        record.type = request.type
        record.amount = request.amount
        record.created = existingRecord?.created ?? Date.now
        record.id = existingRecord?.id ?? UUID()
        record.image = request.image
        
        record.account?.balance += request.type == "incoming" ? request.amount : request.amount * -1
        
        PersistenceController.shared.save(affectedItems: [record, record.account!])
    }
}
