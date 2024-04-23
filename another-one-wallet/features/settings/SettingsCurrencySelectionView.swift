//
//  SettingsCurrencySelectionView.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 23.04.2024.
//

import SwiftUI

struct SettingsCurrencySelectionView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var currenciesWatcherController: CurrenciesWatcherController
    
    var currencies = RealCurrency.allCases
    
    var body: some View {
        List(currencies, id: \.rawValue) { currency in
            Button {
                currenciesWatcherController.setCurrency(currency: currency)
                dismiss()
            } label: {
                HStack {
                    Text(RealCurrency.flagsByCurrencies[currency] ?? "")
                    Text(currency.rawValue)
                    Spacer()
                    
                    if currenciesWatcherController.currency.rawValue == currency.rawValue {
                        Text("Active")
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsCurrencySelectionView()
}
