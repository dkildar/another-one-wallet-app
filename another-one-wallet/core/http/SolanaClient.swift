//
//  SolanaClient.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 15.04.2024.
// 7tkTKTDaLS7Levk9wxA1qEe3HMxKMKCuB6mdKvzevm69

import Foundation
import Combine

actor SolanaClient {
    static var shared = SolanaClient()
    private let httpClient = HttpClient()
    
    func fetchBalance(address: String) async throws -> SolanaBalanceRPCResponse? {
        return try await httpClient.convertToAsync(
            request: httpClient.request(
                urlString: "https://api.mainnet-beta.solana.com",
                method: "POST",
                queryParams: [:],
                headers: [:],
                responseEntity: SolanaBalanceRPCResponse.self,
                body: try? JSONSerialization.data(withJSONObject: [
                    "jsonrpc": "2.0",
                    "id": 1,
                    "method": "getBalance",
                    "params": [address]
                ])
            )
        )
    }
}
