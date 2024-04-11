//
//  CryptoAccountItemView.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 11.04.2024.
//

import SwiftUI
import Combine

struct CryptoAccountItemView: View {
    let account: BankAccount
    
    @State var trc20Account: TRC20AccountResponse? = nil
    @State var cancellable: AnyCancellable? = nil
    init(account: BankAccount) {
        self.account = account
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            ListIconView(string: account.icon ?? "")
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
                if let trc20Account = trc20Account {
                    VStack(alignment: .leading, spacing: 16) {
                        ForEach(trc20Account.withPriceTokens ?? Array(), id: \.self) { token in
                            TRC20ItemView(token: token)
                            
                            if trc20Account.withPriceTokens?.last != token {
                                Divider()
                            }
                        }
                    }.padding(.vertical, 8)
                }
                
            }
        }
        .onAppear {
            Task {
                guard let address = account.address else {
                    return
                }
                
                if (account.cryptoNetwork == "TRC20") {
                    cancellable = await TRC20Client.shared.fetchAccount(address: address)
                        .sink { error in
                            debugPrint("TRC20 account fetching failed with \(error)")
                        } receiveValue: { response in
                            trc20Account = response
                        }
                    
                }
            }
        }
    }
}
