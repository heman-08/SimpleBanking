//
//  TranscationListView.swift
//  TranscationLedger
//
//  Created by ATEU on 2/21/26.
//

import SwiftUI
import SwiftData



struct TransactionListView: View {
    let username: String
    let onLogout: () -> Void
    
    @Query(sort: \Transaction.date, order: .reverse) private var offlineTransactions: [Transaction]
    @Environment(\.modelContext) private var context
    
    @StateObject private var viewModel = TransactionViewModel()
    @StateObject private var sessionManager = SessionManager()
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                
                // --- NEW CUSTOM HEADER ---
                Text("Welcome, \(username)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                    .padding(.top, 10)
                    .padding(.bottom, 15)
                
                // 1. The Dashboard
                DashboardView(transactions: offlineTransactions)
                
                // 2. The List of Transactions
                List {
                    if viewModel.isLoading && offlineTransactions.isEmpty {
                        ProgressView("Fetching from bank...")
                    } else {
                        ForEach(offlineTransactions) { transaction in
                            TransactionRow(transaction: transaction)
                        }
                    }
                }
                .listStyle(.plain)
            }
            // Keep the Logout button in the top right for standard iOS navigation
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Logout") {
                        sessionManager.endSession()
                    }
                    .foregroundColor(.red)
                    .fontWeight(.bold)
                }
            }
            .onAppear {
                sessionManager.startSession()
                if offlineTransactions.isEmpty {
                    Task { await viewModel.syncData(context: context) }
                }
            }
            .simultaneousGesture(
                DragGesture().onChanged { _ in sessionManager.resetTimer() }
            )
            .simultaneousGesture(
                TapGesture().onEnded { sessionManager.resetTimer() }
            )
            .onChange(of: sessionManager.isLoggedOut) { _, isLoggedOut in
                if isLoggedOut {
                    onLogout()
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
