//
//  SettingsCurrencySelectionView.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 23.04.2024.
//

import SwiftUI

struct SettingsCurrencySelectionView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var currenciesWatcherController: CurrenciesWatcherController
    
    var currencies = RealCurrency.allCases
    
    var body: some View {
        List() {
            Section("Pick the primary currency of your funds") {
                ForEach(currencies, id: \.rawValue) { currency in
                    Button {
                        currenciesWatcherController.setCurrency(currency: currency)
                        dismiss()
                    } label: {
                        HStack(alignment: .center) {
                            HStack(alignment: .top) {
                                Text(RealCurrency.flagsByCurrencies[currency] ?? "")
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text(RealCurrency.getCurrencySymbol(currency: currency))
                                            .foregroundStyle(.blue)
                                        Text(currency.rawValue)
                                    }
                                    Text(RealCurrency.getCountryNameByCurrency(currency: currency))
                                        .font(.caption)
                                }
                            }
                            Spacer()
                            
                            if currenciesWatcherController.currency.rawValue == currency.rawValue {
                                Text("Selected")
                                    .foregroundStyle(.gray)
                            }
                        }
                    }
                    .foregroundStyle(colorScheme == .dark ? .white : .black)
                    .padding(.vertical, 2)
                }
            }
        }
    }
}

#Preview {
    SettingsCurrencySelectionView()
}
