//
//  ManagedBankAccountDetailsView.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 13.04.2024.
//

import SwiftUI
import Charts

struct ManagedAccountChartData : Hashable {
    var amount: Double
    var date: Date
}

struct ManagedBankAccountDetailsView: View {
    @Environment(\.managedObjectContext) var context
    @EnvironmentObject var persistenceController: PersistenceController
    
    var account: BankAccount
    
    @FetchRequest var recordsList: FetchedResults<ManagedAccountRecord>
    
    @State var isCreateRecordPresented = false
    
    var balanceChartItems: [ManagedAccountChartData] {
        get {
            var balanceChartItems: [ManagedAccountChartData] = [ManagedAccountChartData(amount: Double(account.balance), date: Date.now)]
            let tempBalance = Double(account.balance)
            
            for record in recordsList {
                guard let recordDate = record.created else {
                    continue
                }
                
                // Calculate chart data
                balanceChartItems.append(ManagedAccountChartData(amount: tempBalance - record.getSignedAmount(), date: recordDate))
            }
            return balanceChartItems
        }
    }
    var records: Array<(Date, [ManagedAccountRecord])> {
        get {
            var recordsMap: [Date: [ManagedAccountRecord]] = [:]
            for record in recordsList {
                guard let recordDate = record.created else {
                    continue
                }
                let date = recordDate.clearTime()!
                if recordsMap[date] == nil {
                    recordsMap[date] = []
                }
                recordsMap[date]?.append(record)
            }
            
            return recordsMap.sorted(by: { $0.0 > $1.0 })
        }
    }
    
    init(account: BankAccount) {
        self.account = account
        
        let predicate = if let id = account.id?.uuidString {
            NSPredicate(format: "account.id=%@", id)
        } else {
            NSPredicate(format: "account.id=%@", UUID().uuidString)
        }
        
        _recordsList = FetchRequest(
            sortDescriptors: [
                NSSortDescriptor(keyPath: \ManagedAccountRecord.created, ascending: false)
            ],
            predicate: predicate
        )
    }
    
    var body: some View {
        VStack {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(String(format: "%.2f", account.balance))
                                .foregroundStyle(.blue)
                                .font(.system(size: 28, weight: .semibold))
                            
                            Spacer()
                            
                            Text(account.getCurrencySymbol())
                                .foregroundStyle(.gray)
                        }
                        Text(account.currency ?? "")
                            .foregroundStyle(.gray)
                            .padding(.bottom, 16)
                        
                        Chart {
                            ForEach(Array(balanceChartItems.enumerated()), id: \.element) { index, item in
                                LineMark(
                                    x: .value("Date", index),
                                    y: .value("Value", item.amount)
                                )
                                .foregroundStyle(.green)
                            }
                        }
                        .chartXAxis {
                            AxisMarks(preset: .aligned, position: .bottom) { value in
                                let date = balanceChartItems[value.index].date
                                AxisGridLine()
                                AxisValueLabel(DateFormatter().string(from: date), centered: true)
                            }
                        }
                    }
                }
                .padding(.vertical, 8)
                
                Section {
                    Button {
                        isCreateRecordPresented.toggle()
                    } label: {
                        Label("Create a record", systemImage: "plus.app")
                    }
                }
                
                ForEach(records, id: \.0) { (date, recordsList) in
                    Section(header: Text(date.formatted(.dateTime.day().month().year()))) {
                        ForEach(recordsList, id: \.self) { record in
                            HistoryRecordItemView(record: record) {
                                account.balance -= record.type == "incoming" ? record.amount : record.amount * -1
                            }
                        }
                    }
                }
                .id(persistenceController.sessionID)
            }
        }
        .sheet(isPresented: $isCreateRecordPresented) {
            CreateAccountRecordView(bankAccount: account)
        }
    }
}
