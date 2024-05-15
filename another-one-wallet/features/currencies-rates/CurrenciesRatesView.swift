//
//  CurrenciesRatesView.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 15.05.2024.
//

import SwiftUI

struct CurrencyExtendedInfoItem: View {
    @Binding var currency: RealCurrency
    
    var body: some View {
        HStack {
            Text(RealCurrency.getCurrencySymbol(currency: currency))
                .foregroundStyle(.blue)
            Text(currency.rawValue)
        }
    }
}

struct CurrenciesRatesView: View {
    @EnvironmentObject var currenciesWatcherController: CurrenciesWatcherController
    @FetchRequest(sortDescriptors: []) var rates: FetchedResults<CurrencyRateWidgetRecord>
    
    @State var isEditPresented = false
    
    var ratesPairs: [(RealCurrency, RealCurrency, Double)] {
        get {
            let allRates = currenciesWatcherController.allRates
            var result: [(RealCurrency, RealCurrency, Double)] = []
            
            allRates.keys.forEach { currency in
                result.append((RealCurrency.USD, RealCurrency(rawValue: currency) ?? .USD, allRates[currency] ?? 0.0))
            }
            
            return result
        }
    }
    
    var body: some View {
        List {
            ListCardView(
                title: .constant("Currencies rates"),
                systemIconName: .constant("chart.bar.doc.horizontal"),
                accentColor: .constant(.green)
            ) {
                if rates.isEmpty {
                    HStack {
                        Text("Not configured yet")
                            .foregroundStyle(.gray)
                            .padding(.vertical, 8)
                    }
                } else {
                    ExchangeRatesListView()
                }
                
            } action: {
                Button {
                    isEditPresented.toggle()
                } label: {
                    Image(systemName: "gear")
                }
            }
            
            FastCurrenciesCalculatorView()
            
            Section("All rates") {
                ForEach(ratesPairs, id: \.2) { (source, target, value) in
                    Grid {
                        GridRow {
                            CurrencyExtendedInfoItem(currency: .constant(source))
                            Image(systemName: "arrow.right")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.gray)
                                .frame(width: 16, height: 16)
                            CurrencyExtendedInfoItem(currency: .constant(target))
                            Spacer()
                            Text(String(format: "%.3f", value))
                                .foregroundStyle(.green)
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $isEditPresented) {
            NavigationView {
                CurrenciesRateWidgetEditorView()
            }
        }
    }
}
