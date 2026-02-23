//
//  TranscationViewModel.swift
//  TranscationLedger
//
//  Created by ATEU on 2/21/26.
//

import Foundation
import SwiftData
import SwiftUI
import Combine

@MainActor // Ensures UI updates happen on the main thread
class TransactionViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let networkService = NetworkService()
    
    func syncData(context: ModelContext) async {
        isLoading = true
        errorMessage = nil
        
        do {
            // 1. Fetch from API
            let fetchedTransactions = try await networkService.fetchTransactions()
            
            // 2. Save to Offline Storage (SwiftData)
            for transaction in fetchedTransactions {
                context.insert(transaction)
            }
            // Context automatically saves in the background
            
        } catch {
            errorMessage = "Failed to connect to the server."
        }
        
        isLoading = false
    }
}
