//
//  ManagedAccountChartView.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 23.04.2024.
//

import SwiftUI
import Charts

struct ManagedAccountChartView: View {
    @Environment(\.managedObjectContext) var context
    @EnvironmentObject var persistenceController: PersistenceController
    
    @FetchRequest var recordsList: FetchedResults<ManagedAccountRecord>
    
    @Binding var account: BankAccount
    
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
    
    init(account: Binding<BankAccount>) {
        self._account = account
        
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
