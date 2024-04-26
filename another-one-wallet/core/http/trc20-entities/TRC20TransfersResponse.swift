//
//  TRC20TransfersResponse.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 25.04.2024.
//

import Foundation

struct TRC20TransferTokenInfoResponse : Codable {
    var tokenAbbr: String = ""
    
    enum CodingKeys: String, CodingKey {
        case tokenAbbr = "tokenAbbr"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.tokenAbbr = try container.decode(String.self, forKey: .tokenAbbr)
    }
}

struct TRC20TransferItemResponse : Codable {
    var transactionId: String = ""
    var fromAddress: String = ""
    var toAddress: String = ""
    var quant: Double = 0.0
    var finalResult: String = ""
    var tokenInfo: TRC20TransferTokenInfoResponse? = nil
    var block: Int64 = 0
    var blockTimestamp: Date? = nil
    
    enum CodingKeys: String, CodingKey {
        case transactionId = "transaction_id"
        case fromAddress = "from_address"
        case toAddress = "to_address"
        case quant = "quant"
        case finalResult = "finalResult"
        case tokenInfo = "tokenInfo"
        case block = "block"
        case blockTimestamp = "block_ts"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.transactionId = try container.decode(String.self, forKey: .transactionId)
        self.fromAddress = try container.decode(String.self, forKey: .fromAddress)
        self.toAddress = try container.decode(String.self, forKey: .toAddress)
        self.quant = Double(try container.decode(String.self, forKey: .quant)) ?? 0.0
        self.finalResult = try container.decode(String.self, forKey: .finalResult)
        self.block = try container.decode(Int64.self, forKey: .block)
        self.tokenInfo = try container.decodeIfPresent(TRC20TransferTokenInfoResponse.self, forKey: .tokenInfo)
        self.blockTimestamp = Date(timeIntervalSince1970: try container.decode(Double.self, forKey: .blockTimestamp) / 1000)
    }
}

struct TRC20TransfersResponse : Codable {
    var tokenTransfers: [TRC20TransferItemResponse] = []
    
    enum CodingKeys: String, CodingKey {
        case tokenTransfers = "token_transfers"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.tokenTransfers = try container.decode([TRC20TransferItemResponse].self, forKey: .tokenTransfers)
    }
}
