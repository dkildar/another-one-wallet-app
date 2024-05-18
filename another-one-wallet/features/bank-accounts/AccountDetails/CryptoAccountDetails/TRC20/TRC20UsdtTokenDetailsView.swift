//
//  TRC20TokenDetails.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 25.04.2024.
//

import SwiftUI
import Pigeon
import Combine

struct TRC20UsdtTokenDetailsView: View {
    @Environment(\.openURL) var openLink
    
    @EnvironmentObject var currenciesWatcherController: CurrenciesWatcherController
    @ObservedObject var stateObject: TRC20DetailsStateObject
    
    @Binding var account: BankAccount
    @Binding var token: CryptoToken
    
    var body: some View {
        ForEach(stateObject.aggregatedTrc20UsdtRecords, id: \.0) { date, recordsList in
            recordsSection(date: date, recordsList: recordsList)
        }
    }
    
    @ViewBuilder
    private func recordsSection(date: Date, recordsList: [TRC20TransferItemResponse]) -> some View {
        let dateFormat = date.formatted(.dateTime.day().month().year())
        Section(dateFormat) {
            ForEach(recordsList, id: \.transactionId) { record in
                CryptoTokenTransactionView(
                    token: $token,
                    incoming: .constant(record.toAddress == account.address),
                    amount: .constant((record.quant / 1000000) * currenciesWatcherController.rateRelatedToUsd),
                    dateFormat: .constant(record.blockTimestamp?.formatted(.dateTime.hour().minute()) ?? ""),
                    detailsLinkURLString: .constant("https://tronscan.org/#/transaction/\(record.transactionId)")
                )
            }
        }
    }
}
