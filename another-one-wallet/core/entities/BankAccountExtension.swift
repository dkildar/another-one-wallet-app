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
        case .Managing: AppCurrency(currency: RealCurrency.init(rawValue: currency ?? "USD") ?? .USD)
        case.LinkedCrypto: AppCurrency(currency: AppCurrency.CryptoCurrencies.init(rawValue: currency ?? "USDT") ?? .USDT)
        case .none:
            fatalError("Not supporting bank account")
        }
    }
    
    func getAccountType() -> BankAccountType {
        return BankAccountType.init(rawValue: type)!
    }
    
    func getCurrencySymbol() -> String {
        return RealCurrency.getCurrencySymbol(currency: RealCurrency(rawValue: currency ?? "USD") ?? .USD)
    }
    
    func getUsdBalance() -> Double {
        let conversionRateFromAccountToUsd = CurrenciesWatcherController.shared.allRates[currency ?? "USD"] ?? 1
        
        return balance * 1/conversionRateFromAccountToUsd
    }
    
    static func getNumberFormatter(currency: RealCurrency = CurrenciesWatcherController.shared.currency) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = RealCurrency.getCurrencySymbol(currency: currency)
        return formatter
    }
}
