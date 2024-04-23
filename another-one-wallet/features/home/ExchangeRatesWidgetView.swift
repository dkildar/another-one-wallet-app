//
//  ExchangeRatesWidgetView.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 23.04.2024.
//

import SwiftUI

struct ExchangeRatesWidgetView: View {
    @FetchRequest(sortDescriptors: []) var rates: FetchedResults<CurrencyRateWidgetRecord>

    @State var isEditPresented = false
    
    var body: some View {
        Section {
            ForEach(rates, id: \.id) { exchangeRate in
                HStack {
                    Text(exchangeRate.from ?? "")
                        .foregroundStyle(.blue)
                    Text("→")
                        .foregroundStyle(.gray)
                    Text(exchangeRate.to ?? "")
                        .foregroundStyle(.blue)
                    Spacer()
                    
                    
                    Text(computeAmount(rate: exchangeRate))
                }
                .padding(.vertical, 4)
            }
            
            if rates.isEmpty {
                HStack {
                    Text("Not configured yet")
                        .foregroundStyle(.gray)
                }
            }
        } header: {
            HStack {
                Text("Currencies rates")
                    .foregroundStyle(.gray)
                
                Spacer()
                
                Button {
                    isEditPresented.toggle()
                } label: {
                    Text("Edit")
                        .font(.system(size: 12))
                }
            }
        }
        .sheet(isPresented: $isEditPresented) {
            NavigationView {
                CurrenciesRateWidgetEditorView()
            }
        }
    }
    
    private func computeAmount(rate: CurrencyRateWidgetRecord) -> String {
        var exchangeRates: [String : Double] = UserDefaults.standard.dictionary(forKey: "ExchangeRates") as? [String : Double] ?? [:]
        
        let from = RealCurrency.init(rawValue: rate.from!)!
        let to = RealCurrency.init(rawValue: rate.to!)!
        let sign = RealCurrency.getCurrencySymbol(currency: to)
        let amount = (exchangeRates[from.rawValue] ?? 0.0) / (exchangeRates[to.rawValue] ?? 1.0)
        
        return String(format: "%.2f", amount) + sign
    }
}
