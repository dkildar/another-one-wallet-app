//
//  BankAccountExtension.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 11.04.2024.
//

import Foundation

enum BankAccountType: Int16 {
    case Managing = 0
    case LinkedCrypto = 1
}

extension BankAccount {
    func getCurrency() -> AppCurrency {
        let accountType = BankAccountType.init(rawValue: type)
        
        return switch accountType {
        case .Managing: AppCurrency(currency: AppCurrency.Currencies.init(rawValue: currency ?? "USD") ?? .USD)
        case.LinkedCrypto: AppCurrency(currency: AppCurrency.CryptoCurrencies.init(rawValue: currency ?? "USDT") ?? .USDT)
        case .none:
            fatalError("Not supporting bank account")
        }
    }
    
    func getAccountType() -> BankAccountType {
        return BankAccountType.init(rawValue: type)!
    }
    
    func getCurrencySymbol() -> String {
        let locale = NSLocale(localeIdentifier: "en")
        if let currency = currency?.uppercased() {
            return locale.displayName(forKey: NSLocale.Key.currencySymbol, value: currency) ?? "$"
        }
        return currency ?? "USD"
    }
}
