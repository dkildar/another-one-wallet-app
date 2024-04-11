/* 
Copyright (c) 2024 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct TRC20AccountResponse : Codable {
	let balance : Int?
	let totalTransactionCount : Int?
	let transactions : Int?
	let withPriceTokens : [WithPriceTokens]?
	let latest_operation_time : Int?
	let address : String?
	let date_created : Int?
	let activated : Bool?

	enum CodingKeys: String, CodingKey {

		case balance = "balance"
		case totalTransactionCount = "totalTransactionCount"
		case transactions = "transactions"
		case withPriceTokens = "withPriceTokens"
		case latest_operation_time = "latest_operation_time"
		case address = "address"
		case date_created = "date_created"
		case activated = "activated"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		balance = try values.decodeIfPresent(Int.self, forKey: .balance)
		totalTransactionCount = try values.decodeIfPresent(Int.self, forKey: .totalTransactionCount)
		transactions = try values.decodeIfPresent(Int.self, forKey: .transactions)
		withPriceTokens = try values.decodeIfPresent([WithPriceTokens].self, forKey: .withPriceTokens)
		latest_operation_time = try values.decodeIfPresent(Int.self, forKey: .latest_operation_time)
		address = try values.decodeIfPresent(String.self, forKey: .address)
		date_created = try values.decodeIfPresent(Int.self, forKey: .date_created)
		activated = try values.decodeIfPresent(Bool.self, forKey: .activated)
	}

}
