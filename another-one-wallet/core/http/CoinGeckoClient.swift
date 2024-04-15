//
//  CoinGeckoClient.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 15.04.2024.
//

import Foundation
import Combine

actor CoinGeckoClient {
    static var shared = CoinGeckoClient()
    private let httpClient = HttpClient()
    
    func fetchPrice(currency: String, opposite: String) async throws -> CoinGeckoPriceResponse? {
        return try await httpClient.convertToAsync(
            request: httpClient.request(
                urlString: "https://api.coingecko.com/api/v3/simple/price",
                method: "GET",
                queryParams: ["ids": currency, "vs_currencies": opposite],
                headers: [:],
                responseEntity: CoinGeckoPriceResponse.self
            )
        )
    }
    
    func fetchTokenDetails(currency: String, opposite: String) async throws -> CoinGeckoTokenDetailsResponse? {
        let response = try await httpClient.convertToAsync(
            request: httpClient.request(
                urlString: "https://api.coingecko.com/api/v3/coins/markets",
                method: "GET",
                queryParams: [
                    "ids": currency,
                    "vs_currency": opposite,
                    "order": "market_cap_desc",
                    "per_page": "1",
                    "sparkline": "true",
                    "price_change_percentage": "24h"
                ],
                headers: [:],
                responseEntity: [CoinGeckoTokenDetailsResponse].self
            )
        )
        guard let response = response else {
            return nil
        }
        
        return response.first
    }
}
