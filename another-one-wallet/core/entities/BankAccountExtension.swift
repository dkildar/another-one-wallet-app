//
//  BankAccountExtension.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 11.04.2024.
//

import Foundation

extension BankAccount {
    func getCurrency() -> Currencies {
        return Currencies.init(rawValue: currency) ?? .USD
    }
}
