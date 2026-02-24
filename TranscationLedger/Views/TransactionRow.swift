//
//  TransactionRow.swift
//  TranscationLedger
//
//  Created by ATEU on 2/21/26.
//

import SwiftUI



struct TransactionRow: View {
    let transaction: Transaction
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.merchantName)
                    .font(.headline)
                Text(transaction.date)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text(String(format: "$%.2f", transaction.amount))
                .font(.headline)
                .foregroundColor(transaction.amount < 0 ? .red : .green)
        }
        .padding(.vertical, 4)
    }
}
