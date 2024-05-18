//
//  TONDetailsView.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 18.05.2024.
//

import Foundation
import Pigeon
import Combine
import SwiftUI

class TONDetailsStateObject : ObservableObject {
    private var cancellable: Set<AnyCancellable> = Set()
    
    @Published var tonTransfersQuery = Query<String, TONTransactionsResponse>(
        key: .tonTransfers,
        keyAdapter: { key, address in key.appending(address) },
        behavior: .startWhenRequested,
        cache: UserDefaultsQueryCache.shared,
        cacheConfig: QueryCacheConfig(
            invalidationPolicy: .expiresAfter(300),
            usagePolicy: .useAndThenFetch
        ),
        fetcher: { address in
            TONClient.shared.fetchTransactions(address: address)
        })
    
    @Published var aggregatedTonRecords: Array<(Date, [TONTransaction])> = []
    
    init() {
        tonTransfersQuery.valuePublisher
            .receive(on: DispatchQueue.main)
            .sink { response in
                DispatchQueue.main.async {
                    withAnimation {
                        self.aggregatedTonRecords = self.buildAggregatedTonRecords(response: response)
                    }
                }
            }
            .store(in: &cancellable)
    }
    
    private func buildAggregatedTonRecords(response: TONTransactionsResponse?) -> Array<(Date, [TONTransaction])> {
        var recordsMap: [Date: [TONTransaction]] = [:]
        for record in response?.result ?? [] {
            guard let recordDate = Date(timeIntervalSince1970: TimeInterval(record.utime ?? 0)).clearTime() else {
                continue
            }
            recordsMap[recordDate, default: []].append(record)
        }
        return recordsMap.sorted(by: { $0.0 > $1.0 })
    }
}
