//
//  FastCurrenciesCalculatorView.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 15.05.2024.
//

import SwiftUI

struct FastCurrenciesCalculatorView: View {
    @EnvironmentObject var currenciesWatcherController: CurrenciesWatcherController
    @FetchRequest(sortDescriptors: []) var rates: FetchedResults<CurrencyRateWidgetRecord>
    
    @State var from: RealCurrency = .USD
    @State var to: RealCurrency = .EUR
    @State var result = 0.0
    
    var body: some View {
        ListCardView(
            title: .constant("Fast rates calculator"),
            systemIconName: .constant("plus.forwardslash.minus"),
            accentColor: .constant(.green)
        ) {
            HStack {
                Picker("From", selection: $from) {
                    ForEach(RealCurrency.allCases, id: \.rawValue) { currency in
                        Text(RealCurrency.getCurrencySymbol(currency: currency) + "(\(currency.rawValue))").tag(currency)
                    }
                }
                .font(.system(size: 14.0))
                .pickerStyle(.wheel)
                .labelsHidden()
                .frame(maxWidth: 96)
                
                Spacer()
                VStack {
                    Text(String(format: "%.2f", result))
                        .foregroundStyle(.green)
                        .font(.system(size: 20))
                        .bold()
                        .contentTransition(.numericText())
                        .monospacedDigit()
                        .transaction { t in
                            t.animation = .default
                        }
                    
                    Button {
                        let temp = from
                        from = to
                        to = temp
                    } label: {
                        Image(systemName: "arrow.swap")
                            .rotationEffect(.degrees(90))
                    }
                    .buttonStyle(BorderedProminentButtonStyle())
                }
                Spacer()
                
                Picker("To", selection: $to) {
                    ForEach(RealCurrency.allCases, id: \.rawValue) { currency in
                        Text(RealCurrency.getCurrencySymbol(currency: currency) + "(\(currency.rawValue))").tag(currency)
                    }
                }
                .font(.system(size: 14.0))
                .pickerStyle(.wheel)
                .labelsHidden()
                .frame(maxWidth: 96)
            }
            .frame(maxWidth: .infinity)
        } action: {
        }
        .onAppear {
            calculate()
        }
        .onChange(of: from) { oldValue, newValue in
            calculate()
        }
        .onChange(of: to) { oldValue, newValue in
            calculate()
        }
    }
    
    private func calculate() {
        let rateRelatedToUsdFrom = currenciesWatcherController.allRates[from.rawValue] ?? 0.0
        let rateRelatedToUsdTo = currenciesWatcherController.allRates[to.rawValue] ?? 1.0
        
        withAnimation {
            result = rateRelatedToUsdTo / rateRelatedToUsdFrom
        }
    }
}
