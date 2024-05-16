//
//  TONClient.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 16.05.2024.
//

import Foundation
import Combine

class TONClient {
    static var shared = TONClient()
    private let httpClient = HttpClient()
    
    func fetchAccountInfo(address: String) async throws -> TONAccountResponse? {
        return try await httpClient.convertToAsync(
            request: httpClient.request(
                urlString: "https://toncenter.com/api/v2/jsonRPC",
                method: "POST",
                queryParams: [:],
                headers: [:],
                responseEntity: TONAccountResponse.self,
                body: try? JSONSerialization.data(withJSONObject: [
                    "jsonrpc": "2.0",
                    "id": 1,
                    "method": "getAddressInformation",
                    "params": [
                        "address": address
                    ]
                ])
            )
        )
    }
}
