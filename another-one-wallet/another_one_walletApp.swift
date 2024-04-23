//
//  another_one_walletApp.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 9.04.2024.
//

import SwiftUI
import WhatsNewKit

@main
struct another_one_walletApp: App {
    let persistenceController = PersistenceController.shared
    let cryptoAccountsController = CryptoAccountsController()
    let currenciesWatcherController = CurrenciesWatcherController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(persistenceController)
                .environmentObject(cryptoAccountsController)
                .environmentObject(currenciesWatcherController)
                .environment(
                    \.whatsNew,
                     WhatsNewEnvironment(
                         whatsNewCollection: [
                             WhatsNew(
                                 version: "1.0.0",
                                 title: "Meet Another one wallet",
                                 features: [
                                    WhatsNew.Feature(
                                        image: WhatsNew.Feature.Image(systemName: "dollarsign.circle"),
                                        title: "Expense Tracking and Management",
                                        subtitle: "Categorize your expenses and track money"
                                    ),
                                    WhatsNew.Feature(
                                        image: WhatsNew.Feature.Image(systemName: "briefcase.circle", foregroundColor: .green),
                                        title: "Cryptocurrency Account Linking",
                                        subtitle: "Securely link your cryptocurrency wallets and view all informarion"
                                    ),
                                    WhatsNew.Feature(
                                        image: WhatsNew.Feature.Image(systemName: "circle.dotted.circle", foregroundColor: .gray),
                                        title: "Aggregated Home Screen",
                                        subtitle: "View all critical financial information at a glance on the home screen"
                                    ),
                                 ]
                             )
                         ]
                     )
                )
                .onAppear {
                    cryptoAccountsController.loadAccounts()
                }
        }
    }
}
