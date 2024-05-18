//
//  ManagedAccountItemView.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 11.04.2024.
//

import SwiftUI

struct ManagedAccountItemView: View {
    @EnvironmentObject var persistenceController: PersistenceController
    @EnvironmentObject var currenciesWatcherController: CurrenciesWatcherController
    
    @Binding var account: BankAccount
    
    @State var isConfirmationPresented = false
    @State var isEditPresented = false
    
    var isSameCurrency: Bool {
        get {
            return account.currency == currenciesWatcherController.currency.rawValue
        }
    }
    
    var totalText: String {
        get {
            let nextCurrency = (isSameCurrency ? RealCurrency(rawValue: account.currency ?? "USD") : currenciesWatcherController.currency) ?? .USD
            let balance = isSameCurrency ? account.balance : account.getUsdBalance() * currenciesWatcherController.rateRelatedToUsd
            
            return "\(BankAccount.getNumberFormatter(currency: nextCurrency).string(from: balance as NSNumber)!)"
        }
    }
    
    var totalInAccountText: String {
        get {
            return "\(BankAccount.getNumberFormatter(currency: RealCurrency(rawValue: account.currency ?? "USD") ?? .USD).string(from: account.balance as NSNumber)!)"
        }
    }
    
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
                
                VStack(alignment: .trailing) {
                    HStack(alignment: .center) {
                        Text(totalText)
                            .font(.caption)
                            .foregroundStyle(Color.blue)
                        
                        Image(systemName: "chevron.right")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.gray)
                            .frame(width: 10, height: 10)
                    }
                    if !isSameCurrency {
                        Text(totalInAccountText)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .swipeActions {
            Button {
                isConfirmationPresented = true
            } label: {
                Image(systemName: "trash.circle")
            }
            .tint(.red)
            
            Button {
                isEditPresented = true
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
            ManagedBankAccountFormView(presetAccount: .constant(account))
                .navigationTitle("Edit an account")
        }
    }
}
