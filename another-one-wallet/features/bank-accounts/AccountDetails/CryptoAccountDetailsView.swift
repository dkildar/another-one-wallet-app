//
//  CryptoAccountDetailsView.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 15.04.2024.
//

import SwiftUI

struct CryptoAccountDetailsView: View {
    var account: BankAccount
    var token: CryptoToken
    
    init(account: BankAccount, token: CryptoToken) {
        self.account = account
        self.token = token
    }
    
    var body: some View {
        VStack {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(String(format: "%.2f", (Double(token.balance ?? "0") ?? 0)))
                                .foregroundStyle(.blue)
                                .font(.system(size: 28, weight: .semibold))
                            
                            Spacer()
                            
                            Text(token.abbr?.uppercased() ?? "")
                                .foregroundStyle(.gray)
                        }
                        Text("≈ " + String(format: "%.2f", (Double(token.usdBalance ?? "0") ?? 0)) + "$")
                            .foregroundStyle(.gray)
                        
                        let originalBalance = (Double(token.usdBalance ?? "0.0") ?? 0.0) / (Double(token.balance ?? "0.0") ?? 0.0)
                        Text("1\(token.abbr?.uppercased() ?? "") = \(String(format: "%.2f", originalBalance))$")
                            .foregroundStyle(.gray)
                            .font(.caption)
                            .padding(.top, 8)
                    }
                }
                .padding(.vertical, 8)
            }
        }
    }
}
