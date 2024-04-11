/* 
Copyright (c) 2024 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct WithPriceTokens : Codable, Hashable {
	let amount : String?
	let tokenPriceInTrx : Double?
	let tokenId : String?
	let balance : String?
	let tokenName : String?
	let tokenDecimal : Int?
	let tokenAbbr : String?
	let tokenCanShow : Int?
	let tokenType : String?
	let vip : Bool?
	let tokenLogo : String?

	enum CodingKeys: String, CodingKey {
		case amount = "amount"
		case tokenPriceInTrx = "tokenPriceInTrx"
		case tokenId = "tokenId"
		case balance = "balance"
		case tokenName = "tokenName"
		case tokenDecimal = "tokenDecimal"
		case tokenAbbr = "tokenAbbr"
		case tokenCanShow = "tokenCanShow"
		case tokenType = "tokenType"
		case vip = "vip"
		case tokenLogo = "tokenLogo"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		tokenPriceInTrx = try values.decodeIfPresent(Double.self, forKey: .tokenPriceInTrx)
		tokenId = try values.decodeIfPresent(String.self, forKey: .tokenId)
		balance = try values.decodeIfPresent(String.self, forKey: .balance)
		tokenName = try values.decodeIfPresent(String.self, forKey: .tokenName)
		tokenDecimal = try values.decodeIfPresent(Int.self, forKey: .tokenDecimal)
		tokenAbbr = try values.decodeIfPresent(String.self, forKey: .tokenAbbr)
		tokenCanShow = try values.decodeIfPresent(Int.self, forKey: .tokenCanShow)
		tokenType = try values.decodeIfPresent(String.self, forKey: .tokenType)
		vip = try values.decodeIfPresent(Bool.self, forKey: .vip)
		tokenLogo = try values.decodeIfPresent(String.self, forKey: .tokenLogo)
        
        do {
            amount = try values.decodeIfPresent(String.self, forKey: .amount)
        } catch {
            amount = try String(values.decode(Double.self, forKey: .amount))
        }
	}

}
