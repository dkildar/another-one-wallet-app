//
//  CoinGeckoMarketData.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 15.04.2024.

import Foundation

struct MarketDataResponse : Codable {
    var price: [Double]
    
    enum CodingKeys: String, CodingKey {
        case price = "price"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.price = try container.decode([Double].self, forKey: .price)
    }
}

struct CoinGeckoTokenDetailsResponse : Codable {
    /**
     "id": "solana",
             "symbol": "sol",
             "name": "Solana",
             "image": "https://assets.coingecko.com/coins/images/4128/large/solana.png?1696504756",
             "current_price": 147.88,
             "market_cap": 66034730118,
             "market_cap_rank": 5,
             "fully_diluted_valuation": 84867008371,
             "total_volume": 7023377867,
             "high_24h": 152.18,
             "low_24h": 134.37,
             "price_change_24h": 9.21,
             "price_change_percentage_24h": 6.6411,
             "market_cap_change_24h": 4487124484,
             "market_cap_change_percentage_24h": 7.29049,
             "circulating_supply": 446603786.712789,
             "total_supply": 573969109.886119,
             "max_supply": null,
             "ath": 259.96,
             "ath_change_percentage": -43.2648,
             "ath_date": "2021-11-06T21:54:35.825Z",
             "atl": 0.500801,
             "atl_change_percentage": 29350.48863,
             "atl_date": "2020-05-11T19:35:23.449Z",
             "roi": null,
             "last_updated": "2024-04-15T04:38:05.896Z",
     */
    var symbol: String
    var image: String
    var currentPrice: Double
    var priceChangePercentage24h: Double
    var marketData: MarketDataResponse
    
    enum CodingKeys: String, CodingKey {
        case symbol = "symbol"
        case image = "image"
        case currentPrice = "current_price"
        case priceChangePercentage24h = "price_change_percentage_24h"
        case marketData = "sparkline_in_7d"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.symbol = try container.decode(String.self, forKey: .symbol)
        self.image = try container.decode(String.self, forKey: .image)
        self.currentPrice = try container.decode(Double.self, forKey: .currentPrice)
        self.priceChangePercentage24h = try container.decode(Double.self, forKey: .priceChangePercentage24h)
        self.marketData = try container.decode(MarketDataResponse.self, forKey: .marketData)
    }
}
