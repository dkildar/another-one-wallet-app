//
//  CoinGeckoPriceResponse.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 15.04.2024.
//

import Foundation

struct PriceResponse : Codable {
    var usd: Double?
    
    enum CodingKeys: String, CodingKey {
        case usd = "usd"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.usd = try container.decodeIfPresent(Double.self, forKey: .usd)
    }
}

struct CoinGeckoPriceResponse : Codable {
    var solana: PriceResponse?
    
    enum CodingKeys: String, CodingKey {
        case solana = "solana"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.solana = try container.decodeIfPresent(PriceResponse.self, forKey: .solana)
    }
}
