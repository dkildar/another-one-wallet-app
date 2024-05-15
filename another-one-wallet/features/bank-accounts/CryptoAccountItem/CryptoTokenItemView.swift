//
//  TRC20ItemView.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 11.04.2024.
//

import SwiftUI

struct CryptoTokenItemView: View {
    @EnvironmentObject var currenciesWatcherController: CurrenciesWatcherController
    
    @Binding var account: BankAccount
    @Binding var token: CryptoToken
    
    var isSameCurrency: Bool {
        get {
            return account.currency == currenciesWatcherController.currency.rawValue
        }
    }
    
    var totalInCurrency: String {
        get {
            let nextBalance = isSameCurrency ? Double(token.usdBalance ?? "0.0") : (Double(token.usdBalance ?? "0.0") ?? 0.0) * currenciesWatcherController.rateRelatedToUsd
            return "\(BankAccount.getNumberFormatter().string(from: nextBalance as! NSNumber)!)"
        }
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
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                HStack(alignment: .center) {
                    Text(String(format: "%.2f", (Double(token.balance ?? "0") ?? 0)))
                        .font(.caption)
                    
                    Image(systemName: "chevron.right")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.gray)
                        .frame(width: 10, height: 10)
                }
                
                Text("≈ " + totalInCurrency)
                    .font(.caption)
                    .foregroundStyle(Color.gray)
            }
        }
    }
}
