//
//  SOLTokenDetailsView.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 19.05.2024.
//

import SwiftUI

struct SOLTokenTransactionItemView: View {
    @Environment(\.openURL) var openLink
    @EnvironmentObject var currenciesWatcherController: CurrenciesWatcherController
    
    @Binding var account: BankAccount
    @Binding var token: CryptoToken
    @Binding var record: SolanaTransactionResponse
    
    var iconName: String {
        get {
            if record.isWithdraw {
                return "percent"
            }
            
            if record.fromAddress != account.address {
                return "arrow.down.right"
            }
            
            return "arrow.up.right"
        }
    }
    
    var labelText: String {
        get {
            if record.isWithdraw {
                return "Staking operation"
            }
            
            if record.fromAddress != account.address {
                return "Received"
            }
            
            return "Sent"
        }
    }
    
    var body: some View {
        CryptoTokenTransactionView(
            token: $token,
            incoming: .constant(record.fromAddress != account.address),
            amount: .constant((record.getAmount(host: account.address ?? ""))),
            dateFormat: .constant(Date(timeIntervalSince1970: TimeInterval(record.result?.blockTime ?? 0)).formatted(.dateTime.hour().minute())),
            detailsLinkURLString: .constant("https://solscan.io/tx/\(record.result?.transaction?.signatures?.first ?? "")"),
            labelIconName: .constant(iconName),
            labelText: .constant(labelText)
        )
    }
}

struct SOLTokenDetailsView: View {
    @EnvironmentObject var currenciesWatcherController: CurrenciesWatcherController
    @ObservedObject var stateObject: SOLDetailsStateObject
    
    @Binding var account: BankAccount
    @Binding var token: CryptoToken
    
    var body: some View {
        ForEach(stateObject.aggregatedSolRecords, id: \.0) { date, recordsList in
            recordsSection(date: date, recordsList: recordsList)
        }
    }
    
    @ViewBuilder
    private func recordsSection(date: Date, recordsList: [SolanaTransactionResponse]) -> some View {
        let dateFormat = date.formatted(.dateTime.day().month().year())
        Section(dateFormat) {
            ForEach(recordsList, id: \.result?.transaction?.signatures?.first) { record in
                SOLTokenTransactionItemView(account: $account, token: $token, record: .constant(record))
            }
        }
    }
}

