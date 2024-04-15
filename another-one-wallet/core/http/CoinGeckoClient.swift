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
            request: httpClient.request(urlString: "https://api.coingecko.com/api/v3/simple/price", method: "GET", queryParams: ["ids": currency, "vs_currencies": opposite], headers: [:], responseEntity: CoinGeckoPriceResponse.self)
        )
    }
}
