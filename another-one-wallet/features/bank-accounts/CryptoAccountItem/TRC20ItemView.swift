//
//  TRC20ItemView.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 11.04.2024.
//

import SwiftUI

struct TRC20ItemView: View {
    var token: WithPriceTokens
    
    var body: some View {
        HStack {
            if let logo = token.tokenLogo {
                AsyncImage(url: URL(string: logo)!) { image in
                    image.image?.resizable()
                }
                    .scaledToFill()
                    .frame(width: 24, height: 24, alignment: .center)
            }
            VStack(alignment: .leading) {
                Text(token.tokenName ?? "")
                    .font(.callout)
                //                Text(account.cryptoNetwork ?? "")
                //                    .font(.caption)
                //                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text(String(format: "%.2f", (Double(token.balance ?? "0") ?? 0) / 1000000))
                .font(.caption)
                .foregroundStyle(Color.blue)
        }
        .clipShape(.rect(cornerRadius: 16))
    }
}
