//
//  CurrenciesRateWidgetEditorView.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 23.04.2024.
//

import SwiftUI

struct CurrencyRateWidgetItemEdit: View {
    @EnvironmentObject var persistenceController: PersistenceController
    
    @State var from: RealCurrency = .USD
    @State var to: RealCurrency = .EUR
    
    var body: some View {
        Section {
            HStack {
                Text("From")
                    .foregroundStyle(.gray)
                Picker("", selection: $from) {
                    ForEach(RealCurrency.allCases, id: \.rawValue) { currency in
                        Text(RealCurrency.getCurrencySymbol(currency: currency) + "(\(currency.rawValue))").tag(currency)
                    }
                }
                .foregroundColor(.blue)
            }
            .padding(.vertical, 2)
            
            HStack {
                Text("To")
                    .foregroundStyle(.gray)
                Picker("", selection: $to) {
                    ForEach(RealCurrency.allCases, id: \.rawValue) { currency in
                        Text(RealCurrency.getCurrencySymbol(currency: currency) + "(\(currency.rawValue))").tag(currency)
                    }
                }
                .foregroundColor(.blue)
            }
            .padding(.vertical, 2)
            
            Button {
                var record = CurrencyRateWidgetRecord(context: persistenceController.container.viewContext)
                record.id = UUID()
                record.from = from.rawValue
                record.to = to.rawValue
                
                persistenceController.save(affectedItems: [record])
            } label: {
                HStack(alignment: .center) {
                    Image(systemName: "plus.circle")
                    Text("Create a currency rate")
                }
            }
            .padding(.vertical, 2)
        }
    }
}

struct CurrenciesRateWidgetEditorView: View {
    @EnvironmentObject var persistenceController: PersistenceController
    @FetchRequest(sortDescriptors: []) var rates: FetchedResults<CurrencyRateWidgetRecord>
    
    var body: some View {
        List {
            if !rates.isEmpty {
                Section("Configured rates") {
                    ForEach(rates, id: \.id) { rate in
                        let fromCurrency = RealCurrency.init(rawValue: rate.from ?? "")
                        let toCurrency = RealCurrency.init(rawValue: rate.to ?? "")
                        
                        HStack {
                            Text(RealCurrency.getCurrencySymbol(currency: fromCurrency!) + "(\(fromCurrency!.rawValue))")
                            Text("→")
                                .foregroundStyle(.gray)
                            Text(RealCurrency.getCurrencySymbol(currency: toCurrency!) + "(\(toCurrency!.rawValue))")
                        }
                        .swipeActions {
                            Button {
                                persistenceController.delete(item: rate)
                            } label: {
                                Image(systemName: "trash.circle")
                            }
                            .tint(.red)
                        }
                    }
                }
            }
            CurrencyRateWidgetItemEdit()
        }
        .navigationTitle("Currencies rates widget settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    CurrenciesRateWidgetEditorView()
}
