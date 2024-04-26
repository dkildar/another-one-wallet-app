//
//  CryptoAccountItemView.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 11.04.2024.
//

import SwiftUI
import Combine

struct CryptoAccountItemView: View {
    @Binding var account: BankAccount
    
    var tokens: [CryptoToken] {
        get {
            return (account.tokens?.array as? [CryptoToken]) ?? []
        }
    }
    
    var body: some View {
        Group {
            HStack {
                ListIconView(string: account.icon ?? "", bgColor: .green)
                    .padding(.trailing, 4)
                VStack(alignment: .leading) {
                    Text(account.name ?? "")
                    Text(account.cryptoNetwork ?? "")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("Total")
                        .font(.caption)
                        .foregroundStyle(Color.gray)
                    Text(String(format: "%.2f", Double(account.balance)) + "$")
                        .font(.caption)
                        .foregroundStyle(Color.green)
                }
            }
            ForEach(tokens, id: \.self) { token in
                NavigationLink {
                    CryptoAccountDetailsView(
                        account: $account,
                        token: .constant(token)
                    )
                        .navigationTitle("\(account.name ?? "") – \(token.name ?? "")")
                } label: {
                    CryptoTokenItemView(token: .constant(token))
                }
                .padding(.leading, 48)
            }
        }
    }
}
