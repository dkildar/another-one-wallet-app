//
//  TONTransactionsResponse.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 16.05.2024.
//

import Foundation

struct TONTransactionAddress : Codable {
    let type : String?
    let account_address : String?
    
    enum CodingKeys: String, CodingKey {
        
        case type = "@type"
        case account_address = "account_address"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        account_address = try values.decodeIfPresent(String.self, forKey: .account_address)
    }
}

struct TONTransactionMsgData : Codable {
    let type : String?
    let body : String?
    let init_state : String?
    
    enum CodingKeys: String, CodingKey {
        
        case type = "@type"
        case body = "body"
        case init_state = "init_state"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        body = try values.decodeIfPresent(String.self, forKey: .body)
        init_state = try values.decodeIfPresent(String.self, forKey: .init_state)
    }
}

struct TONTransactionInMsg : Codable {
    let type : String?
    let source : String?
    let destination : String?
    let value : String?
    let fwd_fee : String?
    let ihr_fee : String?
    let created_lt : String?
    let body_hash : String?
    let msg_data : TONTransactionMsgData?
    let message : String?
    
    enum CodingKeys: String, CodingKey {
        
        case type = "@type"
        case source = "source"
        case destination = "destination"
        case value = "value"
        case fwd_fee = "fwd_fee"
        case ihr_fee = "ihr_fee"
        case created_lt = "created_lt"
        case body_hash = "body_hash"
        case msg_data = "msg_data"
        case message = "message"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        source = try values.decodeIfPresent(String.self, forKey: .source)
        destination = try values.decodeIfPresent(String.self, forKey: .destination)
        value = try values.decodeIfPresent(String.self, forKey: .value)
        fwd_fee = try values.decodeIfPresent(String.self, forKey: .fwd_fee)
        ihr_fee = try values.decodeIfPresent(String.self, forKey: .ihr_fee)
        created_lt = try values.decodeIfPresent(String.self, forKey: .created_lt)
        body_hash = try values.decodeIfPresent(String.self, forKey: .body_hash)
        msg_data = try values.decodeIfPresent(TONTransactionMsgData.self, forKey: .msg_data)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }
    
}

struct TONTransactionID : Codable {
    let type : String?
    let lt : String?
    let value : String?
    
    enum CodingKeys: String, CodingKey {
        
        case type = "@type"
        case lt = "lt"
        case value = "hash"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        lt = try values.decodeIfPresent(String.self, forKey: .lt)
        value = try values.decodeIfPresent(String.self, forKey: .value)
    }
    
}

struct TONTransaction : Codable, Identifiable {
    var id: UUID = UUID()
    
    let type : String?
    let address : TONTransactionAddress?
    let utime : Int?
    let data : String?
    let transaction_id : TONTransactionID?
    let fee : String?
    let storage_fee : String?
    let other_fee : String?
    let in_msg : TONTransactionInMsg?
    let out_msgs : [String]?
    
    enum CodingKeys: String, CodingKey {
        
        case type = "@type"
        case address = "address"
        case utime = "utime"
        case data = "data"
        case transaction_id = "transaction_id"
        case fee = "fee"
        case storage_fee = "storage_fee"
        case other_fee = "other_fee"
        case in_msg = "in_msg"
        case out_msgs = "out_msgs"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        address = try values.decodeIfPresent(TONTransactionAddress.self, forKey: .address)
        utime = try values.decodeIfPresent(Int.self, forKey: .utime)
        data = try values.decodeIfPresent(String.self, forKey: .data)
        transaction_id = try values.decodeIfPresent(TONTransactionID.self, forKey: .transaction_id)
        fee = try values.decodeIfPresent(String.self, forKey: .fee)
        storage_fee = try values.decodeIfPresent(String.self, forKey: .storage_fee)
        other_fee = try values.decodeIfPresent(String.self, forKey: .other_fee)
        in_msg = try values.decodeIfPresent(TONTransactionInMsg.self, forKey: .in_msg)
        out_msgs = try values.decodeIfPresent([String].self, forKey: .out_msgs)
    }
}

struct TONTransactionsResponse : Codable {
    let ok : Bool?
    let result : [TONTransaction]?
    let id : String?
    let jsonrpc : String?
    
    enum CodingKeys: String, CodingKey {
        
        case ok = "ok"
        case result = "result"
        case id = "id"
        case jsonrpc = "jsonrpc"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        ok = try values.decodeIfPresent(Bool.self, forKey: .ok)
        result = try values.decodeIfPresent([TONTransaction].self, forKey: .result)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        jsonrpc = try values.decodeIfPresent(String.self, forKey: .jsonrpc)
    }
    
}
