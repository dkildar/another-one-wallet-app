//
//  AccountView.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 9.04.2024.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink {} label: {
                    Text("Application currency")
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
