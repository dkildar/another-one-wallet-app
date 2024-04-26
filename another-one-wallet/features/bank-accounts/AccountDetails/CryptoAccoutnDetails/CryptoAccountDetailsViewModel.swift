//
//  CryptoAccountDetailsViewModel.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 26.04.2024.
//

import Foundation
import Pigeon
import Combine

class CryptoAccountDetailsViewModel : ObservableObject {
    private var cancellable: Set<AnyCancellable> = Set()
    
    @Published var trc20UsdtTransfersQuery = Query<String, TRC20TransfersResponse>(
        key: .trc20Transfers,
        keyAdapter: { key, address in key.appending(address) },
        behavior: .startWhenRequested,
        cache: UserDefaultsQueryCache.shared,
        cacheConfig: QueryCacheConfig(
            invalidationPolicy: .expiresAfter(300),
            usagePolicy: .useAndThenFetch
        ),
        fetcher: { address in
            TRC20Client.shared.fetchTransfers(address: address, limit: 20)
        })
    
    @Published var aggregatedTrc20UsdtRecords: Array<(Date, [TRC20TransferItemResponse])> = []
    
    init() {
        trc20UsdtTransfersQuery.valuePublisher
            .receive(on: DispatchQueue.main)
            .sink { response in
                self.aggregatedTrc20UsdtRecords = self.buildAggregatedTrc20UsdtRecords(response: response)
            }
            .store(in: &cancellable)
    }
    
    private func buildAggregatedTrc20UsdtRecords(response: TRC20TransfersResponse?) -> Array<(Date, [TRC20TransferItemResponse])> {
        var recordsMap: [Date: [TRC20TransferItemResponse]] = [:]
        for record in response?.tokenTransfers ?? [] {
            guard let recordDate = record.blockTimestamp?.clearTime() else {
                continue
            }
            recordsMap[recordDate, default: []].append(record)
        }
        return recordsMap.sorted(by: { $0.0 > $1.0 })
    }
}
