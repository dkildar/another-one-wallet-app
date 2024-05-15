//
//  ExchangeRatesWidgetView.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 23.04.2024.
//

import SwiftUI

struct ExchangeRatesListView : View {
    @FetchRequest(sortDescriptors: []) var rates: FetchedResults<CurrencyRateWidgetRecord>
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 24) {
            ForEach(rates, id: \.id) { exchangeRate in
                VStack(spacing: 4) {
                    HStack(spacing: 2) {
                        Text(RealCurrency.getCurrencySymbol(currency: RealCurrency.init(rawValue: exchangeRate.from!)!) + "(\(exchangeRate.from ?? ""))")
                            .font(.system(size: 14))
                        Text("→")
                            .font(.system(size: 14))
                            .foregroundStyle(.gray)
                        Text(RealCurrency.getCurrencySymbol(currency: RealCurrency.init(rawValue: exchangeRate.to!)!) + "(\(exchangeRate.to ?? ""))")
                            .font(.system(size: 14))
                    }
                    
                    Text(computeAmount(rate: exchangeRate))
                        .font(.system(size: 24))
                        .foregroundStyle(.green)
                }
            }
        }
        .padding(.top, 12)
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
    
    private func computeAmount(rate: CurrencyRateWidgetRecord) -> String {
        let exchangeRates: [String : Double] = UserDefaults.standard.dictionary(forKey: "ExchangeRates") as? [String : Double] ?? [:]
        
        let from = RealCurrency.init(rawValue: rate.from!)!
        let to = RealCurrency.init(rawValue: rate.to!)!
        let amount = (exchangeRates[to.rawValue] ?? 0.0) / (exchangeRates[from.rawValue] ?? 1.0)
        
        return String(format: "%.2f", amount)
    }
}

struct ExchangeRatesWidgetView: View {
    @FetchRequest(sortDescriptors: []) var rates: FetchedResults<CurrencyRateWidgetRecord>
    
    @State var isEditPresented = false
    
    var body: some View {
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
            HStack(alignment: .center) {
                Text("View more")
                    .font(.caption)
                    .foregroundStyle(.gray)
                
                Image(systemName: "chevron.right")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.gray)
                    .frame(width: 10, height: 10)
            }
        }
        .background {
            NavigationLink("") {
                CurrenciesRatesView()
                    .navigationTitle("Currencies rates")
            }
            .opacity(0)
        }
    }
}
