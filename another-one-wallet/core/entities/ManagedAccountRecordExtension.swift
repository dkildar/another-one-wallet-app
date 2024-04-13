//
//  ManagedAccountRecordExtension.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 13.04.2024.
//

import Foundation

extension ManagedAccountRecord {
    func getSignedAmount() -> Double {
        return type == "incoming" ? amount : -amount
    }
}
