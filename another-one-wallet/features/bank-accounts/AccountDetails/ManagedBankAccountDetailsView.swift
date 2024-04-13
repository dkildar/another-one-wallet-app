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
    
    var account: BankAccount
    
    @State var records: [Date: [ManagedAccountRecord]] = [:]
    @State var balanceChartItems: [ManagedAccountChartData] = []
    
    init(account: BankAccount) {
        self.account = account
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
                            ForEach(balanceChartItems, id: \.self) { item in
                                LineMark(
                                    x: .value("Date", item.date),
                                    y: .value("Value", item.amount)
                                )
                                .foregroundStyle(.green)
                            }
                        }
                    }
                }
                .padding(.vertical, 8)
                ForEach(Array(records.keys), id: \.self) { date in
                    Section(header: Text(date.formatted(.dateTime.day().month().year()))) {
                        ForEach(records[date] ?? [], id: \.self) { record in
                            HistoryRecordItemView(record: record)
                        }
                    }
                }
            }
        }
        .onAppear {
            let request = ManagedAccountRecord.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(keyPath: \ManagedAccountRecord.created, ascending: false)]
            request.predicate = NSPredicate(format: "account.id=%@", account.id?.uuidString ?? "")
            
            do {
                let results = try context.fetch(request)
                var recordsMap: [Date: [ManagedAccountRecord]] = [:]
                var balanceChartItems: [ManagedAccountChartData] = [ManagedAccountChartData(amount: Double(account.balance), date: Date.now)]
                
                // Uses for calucalting chart data
                let tempBalance = Double(account.balance)
                for record in results {
                    guard let recordDate = record.created else {
                        continue
                    }
                    let date = recordDate.clearTime()!
                    if recordsMap[date] == nil {
                        recordsMap[date] = []
                    }
                    recordsMap[date]?.append(record)
                    
                    // Calculate chart data
                    balanceChartItems.append(ManagedAccountChartData(amount: tempBalance - record.getSignedAmount(), date: record.created ?? Date()))
                }
                
                records = recordsMap
                self.balanceChartItems = balanceChartItems
            } catch {
                print("Fetch failed")
            }
        }
    }
}
