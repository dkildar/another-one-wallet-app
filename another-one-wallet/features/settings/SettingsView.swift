//
//  AccountView.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 9.04.2024.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var currenciesWatcherController: CurrenciesWatcherController
    
    var body: some View {
        NavigationStack {
            List {
                NavigationLink {
                    SettingsCurrencySelectionView()
                        .navigationTitle("Application currency")
                } label: {
                    Text("Application currency(\(currenciesWatcherController.currency.rawValue))")
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
