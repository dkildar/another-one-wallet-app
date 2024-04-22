//
//  HttpManager.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 11.04.2024.
//

import Foundation
import Combine

actor TRC20Client {
    static var shared = TRC20Client()
    private let httpClient = HttpClient()
    
    func fetchTokens(address: String) async throws -> TRC20TokensResponse? {
        return try await httpClient.convertToAsync(
            request: httpClient.request(
                urlString: "https://apilist.tronscanapi.com/api/account/tokens",
                method: "GET",
                queryParams: ["address": address],
                headers: ["TRON-PRO-API-KEY": ProcessInfo.processInfo.environment["TRONSCAN_API_KEY"] ?? ""], responseEntity: TRC20TokensResponse.self
            )
        )
    }
}
