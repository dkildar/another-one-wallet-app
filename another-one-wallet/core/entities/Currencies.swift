//
//  Currencies.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 9.04.2024.
//

import Foundation

enum Currencies: Int32 {
    case USD = 0
    case RUB = 1
    case SOL = 2
    case USDT = 3
    case TON = 4
}


var CURRENCIES_MAP = [
    Currencies.USD: "USD",
    Currencies.RUB: "RUB",
    Currencies.SOL: "SOL",
    Currencies.TON: "TON",
    Currencies.USDT: "USDT"
]
