//
//  DashboardView.swift
//  TranscationLedger
//
//  Created by ATEU on 2/24/26.
//

import SwiftUI

struct DashboardView: View {
    // It accepts the list of transactions passed down from the main screen
    var transactions: [Transaction]
    
    // A computed property that adds up all the transaction amounts
    var totalBalance: Double {
        transactions.reduce(0) { sum, transaction in
            sum + transaction.amount
        }
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Text("Total Balance")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
            
            // Displays the calculated balance beautifully
            Text(String(format: "$%.2f", totalBalance))
                .font(.system(size: 42, weight: .bold, design: .rounded))
                // If the balance drops below zero, it turns red!
                .foregroundColor(totalBalance >= 0 ? .primary : .red)
        }
        .padding(.vertical, 25)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(UIColor.secondarySystemBackground))
        )
        .padding(.horizontal)
        .padding(.bottom, 10)
    }
}
