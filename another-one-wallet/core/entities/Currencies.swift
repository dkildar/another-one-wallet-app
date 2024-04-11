//
//  Currencies.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 9.04.2024.
//

import Foundation

struct AppCurrency : Hashable {
    var currency: Locale.Currency
    
    init(currency: Currencies) {
        self.currency = Locale.Currency(currency.rawValue)
    }
    
    init(currency: CryptoCurrencies) {
        self.currency = Locale.Currency(currency.rawValue)
    }
    
    enum Currencies: String, CaseIterable {
        case USD = "USD"
        case RUB = "RUB"
    }
    
    enum CryptoCurrencies: String, CaseIterable {
        case SOL = "SOL"
        case USDT = "USDT"
        case TON = "TON"
    }
}
