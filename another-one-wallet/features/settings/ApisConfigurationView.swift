//
//  ApisConfigurationView.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 25.04.2024.
//

import SwiftUI

struct ApisConfigurationView: View {
    @State var trcApiKey = ""
    @State var solanaApiKey = ""
    @State var freeCurrenciesApiKey = ""
    
    var body: some View {
        List {
            Text("Empty API key means that shared one by application using now")
                .listRowBackground(Color.clear)
                .font(.caption)
                .foregroundStyle(.gray)
            
            Section {
                TextField("API Key", text: $trcApiKey)
            } header: {
                Text("TRC")
            } footer: {
                Text("See http://tronscan.org")
                    .font(.caption)
            }
            
            Section {
                TextField("API Key", text: $freeCurrenciesApiKey)
            } header: {
                Text("Exchange rates")
            } footer: {
                Text("See https://api.freecurrencyapi.com")
                    .font(.caption)
            }
        }
        .onChange(of: trcApiKey) {
            if trcApiKey.isEmpty {
                UserDefaults.standard.removeObject(forKey: "TrcApiKey")
            } else {
                UserDefaults.standard.setValue(trcApiKey, forKey: "TrcApiKey")
            }
        }
        .onChange(of: freeCurrenciesApiKey) {
            if freeCurrenciesApiKey.isEmpty {
                UserDefaults.standard.removeObject(forKey: "FreeCurrApiKey")
            } else {
                UserDefaults.standard.setValue(freeCurrenciesApiKey, forKey: "FreeCurrApiKey")
            }
        }
    }
}

#Preview {
    ApisConfigurationView()
}
