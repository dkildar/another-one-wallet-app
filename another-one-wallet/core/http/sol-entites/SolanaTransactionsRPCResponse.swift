//
//  SolanaTransactionsRPCResponse.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 27.05.2024.
//

import Foundation

import Foundation

// Define the structure for the list of transaction signatures
struct SolanaSignaturesResponse: Codable {
    let jsonrpc: String?
    let result: [SolanaSignatureResult]?
    let id: Int?
    
    enum CodingKeys: String, CodingKey {
        case jsonrpc
        case result
        case id
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        jsonrpc = try container.decodeIfPresent(String.self, forKey: .jsonrpc)
        result = try container.decodeIfPresent([SolanaSignatureResult].self, forKey: .result)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
    }
}

struct SolanaSignatureResult: Codable {
    let blockTime: Int?
    let confirmationStatus: String?
    let err: String?
    let memo: String?
    let signature: String?
    let slot: Int?
    
    enum CodingKeys: String, CodingKey {
        case blockTime
        case confirmationStatus
        case err
        case memo
        case signature
        case slot
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        blockTime = try container.decodeIfPresent(Int.self, forKey: .blockTime)
        confirmationStatus = try container.decodeIfPresent(String.self, forKey: .confirmationStatus)
        err = try container.decodeIfPresent(String.self, forKey: .err)
        memo = try container.decodeIfPresent(String.self, forKey: .memo)
        signature = try container.decodeIfPresent(String.self, forKey: .signature)
        slot = try container.decodeIfPresent(Int.self, forKey: .slot)
    }
}

// Define the structure for transaction details
struct SolanaTransactionResponse: Codable, Identifiable {
    let jsonrpc: String?
    let result: SolanaTransactionResult?
    let id: Int?
    
    var fromAddress: String? {
        get {
            guard let accountKeys = result?.transaction?.message?.accountKeys else {
                return nil
            }
            return accountKeys.first
        }
    }
    
    var amount: Double {
        get {
            guard let preTokenBalances = result?.meta?.preTokenBalances,
                  let postTokenBalances = result?.meta?.postTokenBalances else {
                return 0.0
                }

                var totalPreAmount: Double = 0
                var totalPostAmount: Double = 0
                
                for preBalance in preTokenBalances {
                    if let preAmount = preBalance.uiTokenAmount?.uiAmount {
                        totalPreAmount += preAmount
                    }
                }

                for postBalance in postTokenBalances {
                    if let postAmount = postBalance.uiTokenAmount?.uiAmount {
                        totalPostAmount += postAmount
                    }
                }

                return totalPreAmount - totalPostAmount
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case jsonrpc
        case result
        case id
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        jsonrpc = try container.decodeIfPresent(String.self, forKey: .jsonrpc)
        result = try container.decodeIfPresent(SolanaTransactionResult.self, forKey: .result)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
    }
}

struct SolanaTransactionResult: Codable {
    let blockTime: Int?
    let meta: SolanaTransactionMeta?
    let slot: Int?
    let transaction: SolanaTransaction?
    
    enum CodingKeys: String, CodingKey {
        case blockTime
        case meta
        case slot
        case transaction
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        blockTime = try container.decodeIfPresent(Int.self, forKey: .blockTime)
        meta = try container.decodeIfPresent(SolanaTransactionMeta.self, forKey: .meta)
        slot = try container.decodeIfPresent(Int.self, forKey: .slot)
        transaction = try container.decodeIfPresent(SolanaTransaction.self, forKey: .transaction)
    }
}

struct SolanaTransactionMeta: Codable {
    let computeUnitsConsumed: Int?
    let err: String?
    let fee: Int?
    let loadedAddresses: LoadedAddresses?
    let logMessages: [String]?
    let postBalances: [Int]?
    let postTokenBalances: [TokenBalance]?
    let preBalances: [Int]?
    let preTokenBalances: [TokenBalance]?
    let rewards: [String]?
    let status: Status?
    
    enum CodingKeys: String, CodingKey {
        case computeUnitsConsumed
        case err
        case fee
        case loadedAddresses
        case logMessages
        case postBalances
        case postTokenBalances
        case preBalances
        case preTokenBalances
        case rewards
        case status
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        computeUnitsConsumed = try container.decodeIfPresent(Int.self, forKey: .computeUnitsConsumed)
        err = try container.decodeIfPresent(String.self, forKey: .err)
        fee = try container.decodeIfPresent(Int.self, forKey: .fee)
        loadedAddresses = try container.decodeIfPresent(LoadedAddresses.self, forKey: .loadedAddresses)
        logMessages = try container.decodeIfPresent([String].self, forKey: .logMessages)
        postBalances = try container.decodeIfPresent([Int].self, forKey: .postBalances)
        postTokenBalances = try container.decodeIfPresent([TokenBalance].self, forKey: .postTokenBalances)
        preBalances = try container.decodeIfPresent([Int].self, forKey: .preBalances)
        preTokenBalances = try container.decodeIfPresent([TokenBalance].self, forKey: .preTokenBalances)
        rewards = try container.decodeIfPresent([String].self, forKey: .rewards)
        status = try container.decodeIfPresent(Status.self, forKey: .status)
    }
}

struct LoadedAddresses: Codable {
    let readonly: [String]?
    let writable: [String]?
    
    enum CodingKeys: String, CodingKey {
        case readonly
        case writable
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        readonly = try container.decodeIfPresent([String].self, forKey: .readonly)
        writable = try container.decodeIfPresent([String].self, forKey: .writable)
    }
}

struct TokenBalance: Codable {
    let accountIndex: Int?
    let mint: String?
    let owner: String?
    let programId: String?
    let uiTokenAmount: UiTokenAmount?
    
    enum CodingKeys: String, CodingKey {
        case accountIndex
        case mint
        case owner
        case programId
        case uiTokenAmount
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        accountIndex = try container.decodeIfPresent(Int.self, forKey: .accountIndex)
        mint = try container.decodeIfPresent(String.self, forKey: .mint)
        owner = try container.decodeIfPresent(String.self, forKey: .owner)
        programId = try container.decodeIfPresent(String.self, forKey: .programId)
        uiTokenAmount = try container.decodeIfPresent(UiTokenAmount.self, forKey: .uiTokenAmount)
    }
}

struct UiTokenAmount: Codable {
    let amount: String?
    let decimals: Int?
    let uiAmount: Double?
    let uiAmountString: String?
    
    enum CodingKeys: String, CodingKey {
        case amount
        case decimals
        case uiAmount
        case uiAmountString
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        amount = try container.decodeIfPresent(String.self, forKey: .amount)
        decimals = try container.decodeIfPresent(Int.self, forKey: .decimals)
        uiAmount = try container.decodeIfPresent(Double.self, forKey: .uiAmount)
        uiAmountString = try container.decodeIfPresent(String.self, forKey: .uiAmountString)
    }
}

struct Status: Codable {
    let ok: String?
    
    enum CodingKeys: String, CodingKey {
        case ok
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        ok = try container.decodeIfPresent(String.self, forKey: .ok)
    }
}

struct SolanaTransaction: Codable {
    let message: SolanaTransactionMessage?
    let signatures: [String]?
    
    enum CodingKeys: String, CodingKey {
        case message
        case signatures
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        message = try container.decodeIfPresent(SolanaTransactionMessage.self, forKey: .message)
        signatures = try container.decodeIfPresent([String].self, forKey: .signatures)
    }
}

struct SolanaTransactionMessage: Codable {
    let accountKeys: [String]?
    let header: SolanaTransactionHeader?
    let instructions: [SolanaTransactionInstruction]?
    let recentBlockhash: String?
    
    enum CodingKeys: String, CodingKey {
        case accountKeys
        case header
        case instructions
        case recentBlockhash
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        accountKeys = try container.decodeIfPresent([String].self, forKey: .accountKeys)
        header = try container.decodeIfPresent(SolanaTransactionHeader.self, forKey: .header)
        instructions = try container.decodeIfPresent([SolanaTransactionInstruction].self, forKey: .instructions)
        recentBlockhash = try container.decodeIfPresent(String.self, forKey: .recentBlockhash)
    }
}

struct SolanaTransactionHeader: Codable {
    let numReadonlySignedAccounts: Int?
    let numReadonlyUnsignedAccounts: Int?
    let numRequiredSignatures: Int?
    
    enum CodingKeys: String, CodingKey {
        case numReadonlySignedAccounts
        case numReadonlyUnsignedAccounts
        case numRequiredSignatures
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        numReadonlySignedAccounts = try container.decodeIfPresent(Int.self, forKey: .numReadonlySignedAccounts)
        numReadonlyUnsignedAccounts = try container.decodeIfPresent(Int.self, forKey: .numReadonlyUnsignedAccounts)
        numRequiredSignatures = try container.decodeIfPresent(Int.self, forKey: .numRequiredSignatures)
    }
}

struct SolanaTransactionInstruction: Codable {
    let accounts: [Int]?
    let data: String?
    let programIdIndex: Int?
    let stackHeight: Int?
    
    enum CodingKeys: String, CodingKey {
        case accounts
        case data
        case programIdIndex
        case stackHeight
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        accounts = try container.decodeIfPresent([Int].self, forKey: .accounts)
        data = try container.decodeIfPresent(String.self, forKey: .data)
        programIdIndex = try container.decodeIfPresent(Int.self, forKey: .programIdIndex)
        stackHeight = try container.decodeIfPresent(Int.self, forKey: .stackHeight)
    }
}
