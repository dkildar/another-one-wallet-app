//
//  TONTokenDetailsView.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 18.05.2024.
//

import SwiftUI

struct TONTokenTransactionItemView: View {
    @Environment(\.openURL) var openLink
    @EnvironmentObject var currenciesWatcherController: CurrenciesWatcherController
    
    @Binding var account: BankAccount
    @Binding var token: CryptoToken
    @Binding var record: TONTransaction
    
    var body: some View {
        let doubleAmount = Double(record.in_msg?.value ?? "0.0") ?? 0.0
        
        CryptoTokenTransactionView(
            token: $token,
            incoming: .constant(record.address?.account_address != account.address),
            amount: .constant((doubleAmount / 1000000000)),
            dateFormat: .constant(Date(timeIntervalSince1970: TimeInterval(record.utime ?? 0)).formatted(.dateTime.hour().minute())),
            detailsLinkURLString: .constant("https://tonscan.org/tx/\(record.transaction_id?.value ?? "")")
        )
    }
}

struct TONTokenDetailsView: View {
    @EnvironmentObject var currenciesWatcherController: CurrenciesWatcherController
    @ObservedObject var stateObject: TONDetailsStateObject
    
    @Binding var account: BankAccount
    @Binding var token: CryptoToken
    
    var body: some View {
        ForEach(stateObject.aggregatedTonRecords, id: \.0) { date, recordsList in
            recordsSection(date: date, recordsList: recordsList)
        }
    }
    
    @ViewBuilder
    private func recordsSection(date: Date, recordsList: [TONTransaction]) -> some View {
        let dateFormat = date.formatted(.dateTime.day().month().year())
        Section(dateFormat) {
            ForEach(recordsList) { record in
                TONTokenTransactionItemView(account: $account, token: $token, record: .constant(record))
            }
        }
    }
}
