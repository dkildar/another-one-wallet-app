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
                    HStack(alignment: .center) {
                        ListIconView(string: "dollarsign.arrow.circlepath" , bgColor: .red)
                            .padding(.trailing, 4)
                        Text("Application currency")
                        Spacer()
                        Text(currenciesWatcherController.currency.rawValue)
                            .foregroundStyle(.gray)
                            .font(.caption)
                    }
                    .padding(.vertical, 2)
                }
                
                Section("Extended configuration") {
                    NavigationLink {
                        ApisConfigurationView()
                            .navigationTitle("APIs configuration")
                    } label: {
                        HStack(alignment: .center) {
                            ListIconView(string: "server.rack" , bgColor: .blue)
                                .padding(.trailing, 4)
                            Text("APIs")
                        }
                        .padding(.vertical, 2)
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    SettingsView()
}
