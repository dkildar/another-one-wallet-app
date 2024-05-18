//
//  CryptoAccountItemView.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 11.04.2024.
//

import SwiftUI
import Combine

struct CryptoAccountItemView: View {
    @EnvironmentObject var persistenceController: PersistenceController
    @EnvironmentObject var currenciesWatcherController: CurrenciesWatcherController
    
    @Binding var account: BankAccount
    
    @State var isConfirmationPresented = false
    @State var isEditPresented = false
    
    var tokens: [CryptoToken] {
        get {
            return (account.tokens?.array as? [CryptoToken]) ?? []
        }
    }
    
    var isSameCurrency: Bool {
        get {
            return account.currency == currenciesWatcherController.currency.rawValue
        }
    }
    
    var total: String {
        get {
            let nextBalance = isSameCurrency ? account.balance : account.getUsdBalance() * currenciesWatcherController.rateRelatedToUsd
            return "\(BankAccount.getNumberFormatter().string(from: nextBalance as NSNumber)!)"
        }
    }
    
    var totalInUsd: String {
        get {
            return "\(BankAccount.getNumberFormatter(currency: RealCurrency(rawValue: account.currency ?? "USD") ?? .USD).string(from: account.getUsdBalance() as NSNumber)!)"
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
                    Text(total)
                        .font(.caption)
                        .foregroundStyle(Color.green)
                    if !isSameCurrency {
                        Text(totalInUsd)
                            .font(.caption)
                            .foregroundStyle(Color.gray)
                    }
                }
            }            
            .padding(.vertical, 6)

            ForEach(tokens, id: \.self) { token in
                CryptoTokenItemView(account: $account, token: .constant(token))
                    .background {
                        NavigationLink(
                            "",
                            destination:CryptoAccountDetailsView(
                                account: $account,
                                token: .constant(token)
                            )
                            .navigationTitle("\(account.name ?? "") – \(token.name ?? "")")
                        )
                        .opacity(0)
                    }
                    .padding(.leading, 48)
                    .padding(.vertical, 6)
            }
        }
        .swipeActions {
            Button {
                isConfirmationPresented.toggle()
            } label: {
                Image(systemName: "trash.circle")
            }
            .tint(.red)
            
            Button {
                isEditPresented.toggle()
            } label: {
                Image(systemName: "pencil.circle")
            }
            .tint(.gray)
        }
        .confirmationDialog("Are you sure?", isPresented: $isConfirmationPresented) {
            Button("Yes, delete", role: .destructive) {
                withAnimation {
                    persistenceController.delete(item: account)
                }
            }
        }
        .sheet(isPresented: $isEditPresented) {
            LinkedCryptoAccountFormView(presetAccount: .constant(account))
                .navigationTitle("Edit an account")
        }
    }
}
