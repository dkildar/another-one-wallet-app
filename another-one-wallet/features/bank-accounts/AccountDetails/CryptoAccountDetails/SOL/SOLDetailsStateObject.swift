//
//  SOLDetailsStateObject.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 19.05.2024.
//

import Foundation
import SwiftUI
import Pigeon
import Combine
import SolanaSwift

class SOLDetailsStateObject : ObservableObject {
    private var cancellable: Set<AnyCancellable> = Set()
    
    @Published var solTransfersQuery = Query<String, [SolanaTransactionResponse]>(
        key: .solTransfers,
        keyAdapter: { key, address in key.appending(address) },
        behavior: .startWhenRequested,
        cache: UserDefaultsQueryCache.shared,
        cacheConfig: QueryCacheConfig(
            invalidationPolicy: .expiresAfter(300),
            usagePolicy: .useAndThenFetch
        ),
        fetcher: { address in
            SolanaClient.shared.fetchTransactionsPublisher(address: address)
                .eraseToAnyPublisher()
        })
    
    @Published var aggregatedSolRecords: Array<(Date, [SolanaTransactionResponse])> = []
    
    init() {
        solTransfersQuery.valuePublisher
            .receive(on: DispatchQueue.main)
            .sink { response in
                DispatchQueue.main.async {
                    withAnimation {
                        self.aggregatedSolRecords = self.buildAggregatedTonRecords(response: response)
                    }
                }
            }
            .store(in: &cancellable)
    }
    
    private func buildAggregatedTonRecords(response: [SolanaTransactionResponse]) -> Array<(Date, [SolanaTransactionResponse])> {
        var recordsMap: [Date: [SolanaTransactionResponse]] = [:]
        for record in response {
            guard let recordDate = Date(timeIntervalSince1970: TimeInterval(record.result?.blockTime ?? 0)).clearTime() else {
                continue
            }
            recordsMap[recordDate, default: []].append(record)
        }
        return recordsMap.sorted(by: { $0.0 > $1.0 })
    }
}
