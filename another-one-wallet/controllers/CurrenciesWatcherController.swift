//
//  CurrenciesWatcherController.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 23.04.2024.
//

import Foundation

class CurrenciesWatcherController : ObservableObject {
    private let currenciesClient = RealCurrencyRatesClient()
    
    @Published var currency: RealCurrency = .USD
    @Published var rateRelatedToUsd = 1.0
    @Published var allRates: [String : Double] = [:]
    
    init() {
        loadCurrencyFromDefaults()
        updateRates()
    }
    
    func setCurrency(currency: RealCurrency) {
        let defaults = UserDefaults.standard
        defaults.set(currency.rawValue, forKey: "AppCurrency")
        self.currency = currency
        updateRates()
    }
    
    func loadCurrencyFromDefaults() {
        let defaults = UserDefaults.standard
        self.currency = RealCurrency.init(rawValue: defaults.string(forKey: "AppCurrency") ?? "USD") ?? .USD
    }
    
    func updateRates() {
        Task {
            let response = try? await currenciesClient.getExchangeRates()
            if let response = response {
                debugPrint("RATES ARE", response)
                let convertedResult = response.data[self.currency.rawValue] ?? 1.0
 
                DispatchQueue.main.async {
                    UserDefaults.standard.set(response.data, forKey: "ExchangeRates")
                    self.rateRelatedToUsd = convertedResult
                    self.allRates = response.data
                }
            }
        }
    }
}
