//
//  SolanaClient.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 15.04.2024.

import Foundation
import Combine

class SolanaClient {
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
    
    func fetchTransactionsPublisher(address: String) -> Future<[SolanaTransactionResponse], Error> {
        return Future { promise in
            Task {
                do {
                    promise(.success((try await self.fetchTransactions(address: address)) ?? []))
                } catch {
                    promise(.failure(error))
                }
            }
        }
    }
    
    func fetchTransactions(address: String) async throws -> [SolanaTransactionResponse]? {
        let response = try await httpClient.convertToAsync(
            request: httpClient.request(
                urlString: "https://api.mainnet-beta.solana.com",
                method: "POST",
                queryParams: [:],
                headers: [:],
                responseEntity: SolanaSignaturesResponse.self,
                body: try? JSONSerialization.data(withJSONObject: [
                    "jsonrpc": "2.0",
                    "id": 1,
                    "method": "getConfirmedSignaturesForAddress2",
                    "params": [
                        address,
                        ["limit":50]
                    ]
                ])
            )
        )
        
        let transactions = try await fetchTransactionsDetails(transactions: response?.result?.map({ transaction in
            transaction.signature ?? ""
        }) ?? [])
        
        return transactions?.filter({ transaction in
            return transaction.getAmount(host: address) != 0.0
        })
    }
    
    func fetchTransactionsDetails(transactions: [String]) async throws -> [SolanaTransactionResponse]? {
        let body = transactions.map { id in
            return [
                "jsonrpc": "2.0",
                "id": 1,
                "method": "getConfirmedTransaction",
                "params": [id]
            ]
        }
        return try await httpClient.convertToAsync(
            request: httpClient.request(
                urlString: "https://api.mainnet-beta.solana.com",
                method: "POST",
                queryParams: [:],
                headers: [:],
                responseEntity: [SolanaTransactionResponse].self,
                body: try? JSONSerialization.data(withJSONObject: body)
            )
        )
    }
}
