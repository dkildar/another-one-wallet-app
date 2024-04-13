//
//  TRC20ItemView.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 11.04.2024.
//

import SwiftUI

struct TRC20ItemView: View {
    var token: CryptoToken
    
    init(token: CryptoToken) {
        self.token = token
    }
    
    var body: some View {
        HStack {
            if let logo = token.logo {
                AsyncImage(url: URL(string: logo)!) { image in
                    image.image?.resizable()
                }
                    .scaledToFill()
                    .frame(width: 24, height: 24, alignment: .center)
            }
            VStack(alignment: .leading) {
                Text(token.name ?? "")
                    .font(.callout)
                //                Text(account.cryptoNetwork ?? "")
                //                    .font(.caption)
                //                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text(String(format: "%.2f", (Double(token.balance ?? "0") ?? 0)))
                    .font(.caption)
                Text("≈ " + String(format: "%.2f", (Double(token.usdBalance ?? "0") ?? 0)) + "$")
                    .font(.caption)
                    .foregroundStyle(Color.gray)
            }
        }
    }
}
