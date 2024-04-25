//
//  CurrencyConverterClient.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 23.04.2024.
//

import Foundation

actor RealCurrencyRatesClient {
    static let shared = RealCurrencyRatesClient()
    private let httpClient = HttpClient()
    
    private var exchangeRates : [RealCurrency : Double] = [
        .USD : 1.0 // Base currency
    ]
    
    func getRates() -> [RealCurrency : Double] {
        return exchangeRates
    }
    
    func getExchangeRates() async throws -> ExchangeRatesResponse? {
        return try await httpClient.convertToAsync(
            request: httpClient.request(
                urlString: "https://api.freecurrencyapi.com/v1/latest",
                method: "GET",
                queryParams: ["apikey": UserDefaults.standard.string(forKey: "FreeCurrApiKey") ?? ProcessInfo.processInfo.environment["CURRENCIES_API_KEY"] ?? ""],
                headers: [:],
                responseEntity: ExchangeRatesResponse.self
            )
        )
    }
}
