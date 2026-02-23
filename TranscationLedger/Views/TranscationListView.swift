//
//  TranscationListView.swift
//  TranscationLedger
//
//  Created by ATEU on 2/21/26.
//

import SwiftUI
import SwiftData

import SwiftUI
import SwiftData

struct TransactionListView: View {
    // These get passed in from the Login screen
    let username: String
    let onLogout: () -> Void
    
    @Query(sort: \Transaction.date, order: .reverse) private var offlineTransactions: [Transaction]
    @Environment(\.modelContext) private var context
    
    @StateObject private var viewModel = TransactionViewModel()
    @StateObject private var sessionManager = SessionManager() // Our new timer!
    
    var body: some View {
        NavigationStack {
            List {
                if viewModel.isLoading && offlineTransactions.isEmpty {
                    ProgressView("Fetching from bank...")
                } else {
                    ForEach(offlineTransactions) { transaction in
                        TransactionRow(transaction: transaction)
                    }
                }
            }
            // 1. Setup the Welcome Message and Logout Button
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Welcome, \(username)")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Logout") {
                        sessionManager.endSession()
                    }
                    .foregroundColor(.red)
                    .fontWeight(.bold)
                }
            }
            // 2. Start the timer when the screen loads
            .onAppear {
                sessionManager.startSession()
                if offlineTransactions.isEmpty {
                    Task { await viewModel.syncData(context: context) }
                }
            }
            // 3. The Magic Triggers: Reset the timer on ANY touch or scroll
            .simultaneousGesture(
                DragGesture().onChanged { _ in sessionManager.resetTimer() }
            )
            .simultaneousGesture(
                TapGesture().onEnded { sessionManager.resetTimer() }
            )
            // 4. Listen for the auto-logout signal
            .onChange(of: sessionManager.isLoggedOut) { _, isLoggedOut in
                if isLoggedOut {
                    onLogout() // Tells the LoginView to close this screen
                }
            }
            .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("OK") { viewModel.errorMessage = nil }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
    }
}
