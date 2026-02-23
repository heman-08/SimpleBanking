//
//  TranscationLedgerApp.swift
//  TranscationLedger
//
//  Created by ATEU on 2/21/26.
//

import SwiftUI
import SwiftData
//
//@main
//struct TranscationLedgerApp: App {
//    var sharedModelContainer: ModelContainer = {
//        let schema = Schema([
//            Item.self,
//        ])
//        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//
//        do {
//            return try ModelContainer(for: schema, configurations: [modelConfiguration])
//        } catch {
//            fatalError("Could not create ModelContainer: \(error)")
//        }
//    }()
//
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//        }
//        .modelContainer(sharedModelContainer)
//    }
//}

import SwiftUI
import SwiftData

@main
struct TransactionApp: App {
    var body: some Scene {
        WindowGroup {
//            TransactionListView()
            LoginView()
        }
        // This injects the offline database into the entire app
        .modelContainer(for: Transaction.self)
    }
}
