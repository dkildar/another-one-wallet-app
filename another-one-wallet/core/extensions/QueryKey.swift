//
//  QueryKey.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 26.04.2024.
//

import Foundation
import Pigeon

extension QueryKey {
    static let trc20Transfers: QueryKey = QueryKey(value: "trc20Transfers")
    static let tonTransfers: QueryKey = QueryKey(value: "tonTransfers")
    static let solTransfers: QueryKey = QueryKey(value: "solTransfers")
}
