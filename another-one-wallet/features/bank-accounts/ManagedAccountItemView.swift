//
//  ManagedAccountItemView.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 11.04.2024.
//

import SwiftUI

struct ManagedAccountItemView: View {
    let account: BankAccount
    
    var body: some View {
        HStack(alignment: .center) {
            ListIconView(string: account.icon ?? "")
                .padding(.trailing, 4)
            
            HStack {
                VStack(alignment: .leading) {
                    Text(account.name ?? "")
                    Text(account.getCurrency().currency.identifier)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
        
                Text(String(format: "%.2f", account.balance) + account.getCurrencySymbol())
                    .font(.caption)
                    .foregroundStyle(Color.blue)
            }
        }
    }
}

#Preview {
    ManagedAccountItemView(account: BankAccount())
}
