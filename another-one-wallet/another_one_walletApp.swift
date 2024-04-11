//
//  another_one_walletApp.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 9.04.2024.
//

import SwiftUI

@main
struct another_one_walletApp: App {
    let persistenceController = PersistenceController.shared
    let cryptoAccountsController = CryptoAccountsController()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(cryptoAccountsController)
                .onAppear {
                    cryptoAccountsController.loadAccounts()
                }
        }
    }
}
