//
//  CryptoTokenTransactionView.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 18.05.2024.
//

import SwiftUI

struct CryptoTokenTransactionView: View {
    @Environment(\.openURL) var openLink
    @EnvironmentObject var currenciesWatcherController: CurrenciesWatcherController
    
    @Binding var token: CryptoToken
    @Binding var incoming: Bool
    @Binding var amount: Double
    @Binding var dateFormat: String
    @Binding var detailsLinkURLString: String
    
    var usdAmount: Double {
        get {
            return amount * token.getUsdRate()
        }
    }
    
    var appCurrencyAmount: Double {
        get {
            return usdAmount * currenciesWatcherController.rateRelatedToUsd
        }
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: incoming ? "arrow.down.right" : "arrow.up.right")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 10, height: 10)
                    Text(incoming ? "Received" : "Sent")
                        .font(.system(size: 14))
                }
                .foregroundColor(.blue)
                .padding(.bottom, 4)
                
                Text("\(incoming ? "+" : "-")\(String(format: "%.2f", amount))\((token.abbr ?? "").uppercased())")
                    .foregroundStyle(incoming ? .green : .red)
                
                Text(BankAccount.getNumberFormatter().string(from: appCurrencyAmount as NSNumber)!)
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            Spacer()
            Text(dateFormat)
                .font(.caption)
                .foregroundStyle(.gray)
        }
        .padding(.vertical, 4)
        .swipeActions {
            Button {
                openLink(URL(string: detailsLinkURLString)!)
            } label: {
                Image(systemName: "plus.magnifyingglass")
            }
        }
    }
}
