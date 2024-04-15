//
//  AccountPopulator.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 15.04.2024.
//

import Foundation
import CoreData

class AccountPopulator {
    let viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
    }
    
    func populate(account: BankAccount, address: String) async throws {
        fatalError("Account populator not implemented")
    }
}
