//
//  ExchangeRateApi.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 15.04.2024.
//

import Foundation

struct ExchangeRateResponse : Codable {
    var rates: [String: String]
    
    enum CodingKeys: String, CodingKey {
        case rates = "rates"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.rates = try container.decode([String : String].self, forKey: .rates)
    }
}

actor ExchangeRateApi {
    private let shared = ExchangeRateApi()
    private let httpClient = HttpClient()
    
    func getUsdRate() async throws -> ExchangeRateResponse? {
        return try? await httpClient.convertToAsync(
            request: httpClient.request(
                urlString: "https://api.exchangerate-api.com/v4/latest/USD",
                method: "GET",
                queryParams: [:],
                headers: [:],
                responseEntity: ExchangeRateResponse.self
            )
        )
    }
}
