//
//  ExchangeRatesResponse.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 23.04.2024.
//

import Foundation

struct ExchangeRatesResponse : Codable {
    var data: [String : Double]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.data = try container.decode([String : Double].self, forKey: .data)
    }
}
