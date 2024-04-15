//
//  CryptoAccountItemView.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 11.04.2024.
//

import SwiftUI
import Combine

struct CryptoAccountItemView: View {
    @ObservedObject var account: BankAccount
    @State var tokens: [CryptoToken] = []
    
    init(account: BankAccount) {
        self.account = account
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
            ForEach(tokens, id: \.id) { token in
                NavigationLink {
                    BankAccountDetailsView(account: account, token: token)
                        .navigationTitle("\(account.name ?? "") – \(token.name ?? "")")
                } label: {
                    CryptoTokenItemView(token: token)
                }
                .padding(.leading, 48)
            }
        }
        .onAppear {
            tokens = account.tokens?.array as! [CryptoToken]
        }
    }
}
