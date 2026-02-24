//
//  DashboardView.swift
//  TranscationLedger
//
//  Created by ATEU on 2/24/26.
//

import SwiftUI

struct DashboardView: View {
    var transactions: [Transaction]
    
    // This state controls whether the balance is visible
    @State private var isBalanceVisible = false
    
    var totalBalance: Double {
        transactions.reduce(0) { sum, transaction in
            sum + transaction.amount
        }
    }
    
    var body: some View {
        VStack(spacing: 8) {
            HStack(alignment: .center, spacing: 10) {
                Text("Total Balance")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
                
                // The Eye Button
                Button(action: {
                    isBalanceVisible.toggle()
                }) {
                    Image(systemName: isBalanceVisible ? "eye" : "eye.slash")
                        .foregroundColor(.secondary)
                }
            }
            
            // Show the real balance OR a masked string
            if isBalanceVisible {
                Text(String(format: "$%.2f", totalBalance))
                    .font(.system(size: 42, weight: .bold, design: .rounded))
                    .foregroundColor(totalBalance >= 0 ? .primary : .red)
            } else {
                Text("$••••••")
                    .font(.system(size: 42, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
            }
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
