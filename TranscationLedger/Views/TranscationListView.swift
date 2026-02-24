//
//  TranscationListView.swift
//  TranscationLedger
//
//  Created by ATEU on 2/21/26.
//

import SwiftUI
import SwiftData

// NEW: An Enum to track our filter choices
enum TransactionFilter: String, CaseIterable {
    case last10 = "Last 10"
    case last20 = "Last 20"
    case custom = "Custom Date"
}

struct TransactionListView: View {
    let username: String
    let onLogout: () -> Void
    
    @Query(sort: \Transaction.date, order: .reverse) private var offlineTransactions: [Transaction]
    @Environment(\.modelContext) private var context
    
    @StateObject private var viewModel = TransactionViewModel()
    @StateObject private var sessionManager = SessionManager()
    
    @State private var isListExpanded = false
    
    // NEW: Filter States
    @State private var selectedFilter: TransactionFilter = .last10
    @State private var startDate = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
    @State private var endDate = Date()
    
    // NEW: The computed property that actively filters the list
    var filteredTransactions: [Transaction] {
        switch selectedFilter {
        case .last10:
            return Array(offlineTransactions.prefix(10))
        case .last20:
            return Array(offlineTransactions.prefix(20))
        case .custom:
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd" // Matches our JSON format
            
            return offlineTransactions.filter { transaction in
                guard let tDate = formatter.date(from: transaction.date) else { return false }
                let start = Calendar.current.startOfDay(for: startDate)
                let end = Calendar.current.startOfDay(for: endDate).addingTimeInterval(86399) // End of the day
                return tDate >= start && tDate <= end
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                
                Text("Welcome, \(username)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                    .padding(.top, 10)
                    .padding(.bottom, 15)
                
                DashboardView(transactions: offlineTransactions) // Keep full balance
                
                // --- THE COLLAPSIBLE HEADER WITH DROPDOWN ---
                HStack {
                    Button(action: {
                        withAnimation(.easeInOut) { isListExpanded.toggle() }
                    }) {
                        HStack {
                            Text("Recent Transactions")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Image(systemName: "chevron.down")
                                .rotationEffect(.degrees(isListExpanded ? 0 : -90))
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Spacer()
                    
                    // NEW: The Dropdown Menu Button
                    if isListExpanded {
                        Menu {
                        Picker("Filter", selection: $selectedFilter) {
                            ForEach(TransactionFilter.allCases, id: \.self) { filter in
                                Text(filter.rawValue).tag(filter)
                            }
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 15)
                
                // NEW: Show Date Pickers if "Custom Date" is selected
                if isListExpanded && selectedFilter == .custom {
                    VStack {
                        DatePicker("From", selection: $startDate, displayedComponents: .date)
                        DatePicker("To", selection: $endDate, displayedComponents: .date)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                }
                
                // --- THE LIST (Now uses `filteredTransactions`) ---
                if isListExpanded {
                    List {
                        if viewModel.isLoading && offlineTransactions.isEmpty {
                            ProgressView("Fetching from bank...")
                        } else {
                            // Notice we iterate over the filtered list here!
                            ForEach(filteredTransactions) { transaction in
                                TransactionRow(transaction: transaction)
                            }
                        }
                    }
                    .listStyle(.plain)
                } else {
                    Spacer()
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Logout") {
                        sessionManager.endSession()
                        onLogout()
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
            .simultaneousGesture(DragGesture().onChanged { _ in sessionManager.resetTimer() })
            .simultaneousGesture(TapGesture().onEnded { sessionManager.resetTimer() })
            .alert("Session Timed Out", isPresented: $sessionManager.hasTimedOut) {
                Button("OK") { onLogout() }
            } message: {
                Text("For your security, you have been automatically logged out due to inactivity.")
            }
            .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("OK") { viewModel.errorMessage = nil }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
    }
}

