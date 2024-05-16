//
//  TONAccountResponse.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 16.05.2024.
//

import Foundation

struct TONAccountResponseResult : Codable {
    var balance: String
    
    enum CodingKeys: String, CodingKey {
        case balance = "balance"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.balance = try container.decode(String.self, forKey: .balance)
    }
}

struct TONAccountResponse : Codable {
    var result: TONAccountResponseResult
    
    enum CodingKeys : String, CodingKey {
        case result = "result"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.result = try container.decode(TONAccountResponseResult.self, forKey: .result)
    }
}
