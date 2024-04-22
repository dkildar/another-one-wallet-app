//
//  CurrenciesWatcherController.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 23.04.2024.
//

import Foundation

class CurrenciesWatcherController : ObservableObject {
    private let currencyConverter = CurrencyConverter()
    
    @Published var currency: Currency = .USD
    @Published var rateRelatedToUsd = 1.0
    @Published var timerInterval = 30.0
    
    init() {
        loadCurrencyFromDefaults()
        updateRates()
        _ = Timer(timeInterval: timerInterval, repeats: true) { _ in
            self.updateRates()
        }
    }
    
    func setCurrency(currency: Currency) {
        let defaults = UserDefaults.standard
        defaults.set(currency.rawValue, forKey: "AppCurrency")
        self.currency = currency
        updateRates()
    }
    
    func loadCurrencyFromDefaults() {
        let defaults = UserDefaults.standard
        self.currency = Currency.init(rawValue: defaults.string(forKey: "AppCurrency") ?? "USD") ?? .USD
    }
    
    func updateRates() {
        currencyConverter.updateExchangeRates(completion: {
            // The code inside here runs after all the data is fetched.
            
            let doubleResult = self.currencyConverter.convert(1, valueCurrency: .USD, outputCurrency: self.currency)
            self.rateRelatedToUsd = doubleResult ?? 1.0
        })
    }
}
