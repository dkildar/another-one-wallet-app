//
//  TRC20TokenDetails.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 25.04.2024.
//

import SwiftUI
import Pigeon
import Combine

struct TRC20TokenDetails: View {
    @Environment(\.openURL) var openLink
    @EnvironmentObject var currenciesWatcherController: CurrenciesWatcherController
    
    @Binding var account: BankAccount
    @Binding var token: CryptoToken
    @Binding var transfers: TRC20TransfersResponse?
    
    var aggregatedRecords: Array<(Date, [TRC20TransferItemResponse])> {
        var recordsMap: [Date: [TRC20TransferItemResponse]] = [:]
        for record in transfers?.tokenTransfers ?? [] {
            guard let recordDate = record.blockTimestamp?.clearTime() else {
                continue
            }
            recordsMap[recordDate, default: []].append(record)
        }
        return recordsMap.sorted(by: { $0.0 > $1.0 })
    }
    
    var body: some View {
        ForEach(aggregatedRecords, id: \.0) { date, recordsList in
            recordsSection(date: date, recordsList: recordsList)
        }
    }
    
    @ViewBuilder
    private func recordsSection(date: Date, recordsList: [TRC20TransferItemResponse]) -> some View {
        let dateFormat = date.formatted(.dateTime.day().month().year())
        Section(dateFormat) {
            ForEach(recordsList, id: \.transactionId) { record in
                recordView(record: record)
                    .swipeActions {
                        Button {
                            openLink(URL(string: "https://tronscan.org/#/transaction/\(record.transactionId)")!)
                        } label: {
                            Image(systemName: "plus.magnifyingglass")
                        }
                    }
            }
        }
    }
    
    @ViewBuilder
    private func recordView(record: TRC20TransferItemResponse) -> some View {
        let incoming = record.toAddress == account.address
        let amount = record.quant * currenciesWatcherController.rateRelatedToUsd
        let symbol = RealCurrency.getCurrencySymbol(currency: currenciesWatcherController.currency)
        let dateFormat = record.blockTimestamp?.formatted(.dateTime.hour().minute()) ?? ""
        
        HStack(alignment: .top, spacing: 8) {
            VStack(alignment: .leading, spacing: 8) {
                Text(incoming ? "Received" : "Sent")
                    .font(.system(size: 14))
                Text("\(incoming ? "+" : "-")\(String(format: "%.2f", amount / 1000000))\(symbol)")
                    .foregroundStyle(incoming ? .green : .red)
            }
            Spacer()
            Text(dateFormat)
                .font(.caption)
                .foregroundStyle(.gray)
        }
        .padding(.vertical, 4)
    }
}
