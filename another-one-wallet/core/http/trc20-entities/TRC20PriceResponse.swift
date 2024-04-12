//
//  TRC20PriceResponse.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 11.04.2024.
//

import Foundation

struct TRC20PriceResponse : Codable, Hashable {
    /*
     "price_in_trx": "1.000000000000000000",
         "percent_change_24h": "-1.32633933",
         "market_cap": "5924627157.48",
         "volume_percent_change_24h": "-14.5509",
         "price_in_usd": "0.06510875200109231",
         "volume_24h": "185091667.4531934",
         "market_cap_percent_change_24h": "-1.3392",
         "from": "coinmarketcap",
         "time": 1680505501491,
         "token": "trx"
     */
    let priceInTrx: String?
    let percentChange24h: String?
    let priceInUsd: String?
    
    enum CodingKeys : String, CodingKey {
        case priceInTrx = "price_in_trx"
        case percentChange24h = "percent_change_24h"
        case priceInUsd = "price_in_usd"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        priceInTrx = try values.decodeIfPresent(String.self, forKey: .priceInTrx)
        percentChange24h = try values.decodeIfPresent(String.self, forKey: .percentChange24h)
        priceInUsd = try values.decodeIfPresent(String.self, forKey: .priceInUsd)
    }
}
