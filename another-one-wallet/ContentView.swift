//
//  ContentView.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 9.04.2024.
//

import SwiftUI
import CoreData
import WhatsNewKit
import ImageViewer

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var imageViewerController: ImageViewerController
    
    @State var currentTab = 1
    
    var body: some View {
        NavigationView {
            TabView(selection: $currentTab) {
                HomeView().tabItem {
                    VStack {
                        Image(systemName: "house")
                        Text("Home")
                    }
                }.tag(1)
                BankAccountsView().tabItem {
                    VStack {
                        Image(systemName: "tray.2")
                        Text("Accounts")
                    }
                }.tag(2)
                SettingsView().tabItem {
                    VStack {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
                }.tag(3)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .whatsNewSheet()
        .overlay(
            Group {
                if let image = imageViewerController.image {
                    ImageViewer(image: .constant(image), viewerShown: $imageViewerController.isViewerPresented)
                }
            }
        )
        .tint(colorScheme == .dark ? .white : .black)
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
