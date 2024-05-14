//
//  Currencies.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 9.04.2024.
//

import Foundation

enum RealCurrency : String, CaseIterable {
    
    case AUD = "AUD"; case INR = "INR"; case TRY = "TRY"
    case BGN = "BGN"; case ISK = "ISK"; case USD = "USD"
    case BRL = "BRL"; case JPY = "JPY"; case ZAR = "ZAR"
    case CAD = "CAD"; case KRW = "KRW"
    case CHF = "CHF"; case MXN = "MXN"
    case CNY = "CNY"; case MYR = "MYR"
    case CZK = "CZK"; case NOK = "NOK"
    case DKK = "DKK"; case NZD = "NZD"
    case EUR = "EUR"; case PHP = "PHP"
    case GBP = "GBP"; case PLN = "PLN"
    case HKD = "HKD"; case RON = "RON"
    case HRK = "HRK"; case RUB = "RUB"
    case HUF = "HUF"; case SEK = "SEK"
    case IDR = "IDR"; case SGD = "SGD"
    case ILS = "ILS"; case THB = "THB"
    
    // Public Static Methods:
    /** Returns a currency name with it's flag (🇺🇸 USD, for example). */
    static func nameWithFlag(for currency : RealCurrency) -> String {
        return (RealCurrency.flagsByCurrencies[currency] ?? "?") + " " + currency.rawValue
    }
    
    // Public Properties:
    /** Returns an array with all currency names and their respective flags. */
    static let allNamesWithFlags : [String] = {
        var namesWithFlags : [String] = []
        for currency in RealCurrency.allCases {
            namesWithFlags.append(RealCurrency.nameWithFlag(for: currency))
        }
        return namesWithFlags
    }()
    
    static let flagsByCurrencies : [RealCurrency : String] = [
        .AUD : "🇦🇺", .INR : "🇮🇳", .TRY : "🇹🇷",
        .BGN : "🇧🇬", .ISK : "🇮🇸", .USD : "🇺🇸",
        .BRL : "🇧🇷", .JPY : "🇯🇵", .ZAR : "🇿🇦",
        .CAD : "🇨🇦", .KRW : "🇰🇷",
        .CHF : "🇨🇭", .MXN : "🇲🇽",
        .CNY : "🇨🇳", .MYR : "🇲🇾",
        .CZK : "🇨🇿", .NOK : "🇳🇴",
        .DKK : "🇩🇰", .NZD : "🇳🇿",
        .EUR : "🇪🇺", .PHP : "🇵🇭",
        .GBP : "🇬🇧", .PLN : "🇵🇱",
        .HKD : "🇭🇰", .RON : "🇷🇴",
        .HRK : "🇭🇷", .RUB : "🇷🇺",
        .HUF : "🇭🇺", .SEK : "🇸🇪",
        .IDR : "🇮🇩", .SGD : "🇸🇬",
        .ILS : "🇮🇱", .THB : "🇹🇭",
    ]
    
    static let localesByCurrencies: [RealCurrency : String] = [
        .AUD : "en_AU", .INR : "bn_IN", .TRY : "tr_TR",
        .BGN : "bg_BG", .ISK : "is_IS", .USD : "en_US",
        .BRL : "pt_BR", .JPY : "ja_JP", .ZAR : "af_ZA",
        .CAD : "en_CA", .KRW : "ko_KR",
        .CHF : "de_CH", .MXN : "es_MX",
        .CNY : "zh_CN", .MYR : "ms_MY",
        .CZK : "cs_CZ", .NOK : "se_NO",
        .DKK : "da_DK", .NZD : "en_NZ",
        .EUR : "en_US", .PHP : "en_PH",
        .GBP : "en_UK", .PLN : "pl_PL",
        .HKD : "zh_HK", .RON : "ro_RO",
        .HRK : "hr_HR", .RUB : "ru_RU",
        .HUF : "hu_HU", .SEK : "sv_FI",
        .IDR : "id_ID", .SGD : "zh_SG",
        .ILS : "he_IL", .THB : "th_TH",
    ]
    
    static func getCurrencySymbol(currency: RealCurrency) -> String {
        let locale = NSLocale(localeIdentifier: localesByCurrencies[currency] ?? "en_US")
        
        if currency == .EUR {
            return "€"
        }
        
        return locale.displayName(forKey: NSLocale.Key.currencySymbol, value: currency.rawValue) ?? "$"
    }
    
    static func getCountryNameByCurrency(currency: RealCurrency) -> String {
        let locale = NSLocale(localeIdentifier: localesByCurrencies[currency] ?? "en_US")
        
        if currency == .EUR {
            return "European Union"
        }
        
        return locale.localizedString(forLocaleIdentifier: localesByCurrencies[currency] ?? "en_US")
    }
}

struct AppCurrency : Hashable {
    var currency: Locale.Currency
    
    init(currency: RealCurrency) {
        self.currency = Locale.Currency(currency.rawValue)
    }
    
    init(currency: CryptoCurrencies) {
        self.currency = Locale.Currency(currency.rawValue)
    }
    
    enum CryptoCurrencies: String, CaseIterable {
        case SOL = "SOL"
        case USDT = "USDT"
        case TON = "TON"
    }
    
    enum CryptoNetwork: String, CaseIterable {
        case TRC20 = "TRC20"
        case SOL = "SOL"
    }
}
