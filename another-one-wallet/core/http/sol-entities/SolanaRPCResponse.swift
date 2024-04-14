//
//  SolanaRPCResponse.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 15.04.2024.
//

/**
 {
     "jsonrpc": "2.0",
     "result": {
         "context": {
             "apiVersion": "1.17.28",
             "slot": 260125255
         },
         "value": 6348499411
     },
     "id": 1
 }
 */

import Foundation

class SolanaBalanceRPCResultResponse : Codable {
    var value: Int
    
    enum CodingKeys : String, CodingKey {
        case value = "value"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.value = try container.decode(Int.self, forKey: .value)
    }
}

class SolanaBalanceRPCResponse : Codable {
    var result: SolanaBalanceRPCResultResponse
    
    enum CodingKeys: String, CodingKey {
        case result = "result"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.result = try container.decode(SolanaBalanceRPCResultResponse.self, forKey: .result)
    }
}
