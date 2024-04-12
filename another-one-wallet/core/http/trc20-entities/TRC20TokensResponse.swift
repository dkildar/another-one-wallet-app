/*
Copyright (c) 2024 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/



import Foundation

struct TokenResponse : Codable, Hashable {
//    let amount : String?
    let quantity : String?
    let tokenId : String?
    let level : String?
    let tokenPriceInUsd : Double?
    let tokenName : String?
    let tokenAbbr : String?
    let tokenCanShow : Double?
    let tokenLogo : String?
    let tokenPriceInTrx : Double?
    let amountInUsd : Double?
    let balance : String?
    let tokenDecimal : Double?
    let tokenType : String?
    let vip : Bool?

    enum CodingKeys: String, CodingKey {
//        case amount = "amount"
        case quantity = "quantity"
        case tokenId = "tokenId"
        case level = "level"
        case tokenPriceInUsd = "tokenPriceInUsd"
        case tokenName = "tokenName"
        case tokenAbbr = "tokenAbbr"
        case tokenCanShow = "tokenCanShow"
        case tokenLogo = "tokenLogo"
        case tokenPriceInTrx = "tokenPriceInTrx"
        case amountInUsd = "amountInUsd"
        case balance = "balance"
        case tokenDecimal = "tokenDecimal"
        case tokenType = "tokenType"
        case vip = "vip"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
//        amount = try values.decodeIfPresent(String.self, forKey: .amount)
//        quantity = try values.decodeIfPresent(String.self, forKey: .quantity)
        tokenId = try values.decodeIfPresent(String.self, forKey: .tokenId)
        level = try values.decodeIfPresent(String.self, forKey: .level)
        tokenPriceInUsd = try values.decodeIfPresent(Double.self, forKey: .tokenPriceInUsd)
        tokenName = try values.decodeIfPresent(String.self, forKey: .tokenName)
        tokenAbbr = try values.decodeIfPresent(String.self, forKey: .tokenAbbr)
        tokenCanShow = try values.decodeIfPresent(Double.self, forKey: .tokenCanShow)
        tokenLogo = try values.decodeIfPresent(String.self, forKey: .tokenLogo)
        tokenPriceInTrx = try values.decodeIfPresent(Double.self, forKey: .tokenPriceInTrx)
        amountInUsd = try values.decodeIfPresent(Double.self, forKey: .amountInUsd)
        balance = try values.decodeIfPresent(String.self, forKey: .balance)
        tokenDecimal = try values.decodeIfPresent(Double.self, forKey: .tokenDecimal)
        tokenType = try values.decodeIfPresent(String.self, forKey: .tokenType)
        vip = try values.decodeIfPresent(Bool.self, forKey: .vip)
        
        do {
            quantity = try values.decodeIfPresent(String.self, forKey: .quantity)
        } catch {
            quantity = try String(values.decode(Double.self, forKey: .quantity))
        }
    }

}

struct TRC20TokensResponse : Codable, Hashable {
    var data: [TokenResponse]?
    
    enum CodingKeys : String, CodingKey {
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.data = try container.decodeIfPresent([TokenResponse].self, forKey: .data)
    }
}
