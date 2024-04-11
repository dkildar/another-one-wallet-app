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
        HStack(alignment: .top) {
            ListIconView(string: account.icon ?? "", bgColor: .green)
                .padding(.trailing, 4)
            
            VStack(alignment: .leading) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(account.name ?? "")
                        Text(account.cryptoNetwork ?? "")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    Text(String(account.balance))
                        .font(.caption)
                        .foregroundStyle(Color.blue)
                }
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(tokens, id: \.id) { token in
                        TRC20ItemView(token: token)
                        
                        if tokens.last != token {
                            Divider()
                        }
                    }
                }.padding(.top, 16)
            }
        }
        .onAppear {
            tokens = account.tokens?.array as! [CryptoToken]
        }
    }
}
