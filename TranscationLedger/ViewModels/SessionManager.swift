//
//  SessionManager.swift
//  TranscationLedger
//
//  Created by ATEU on 2/23/26.
//


import Foundation
import SwiftUI
import Combine

import Foundation
import SwiftUI

@MainActor
class SessionManager: ObservableObject {
    // Changed this variable name to reflect our new logic
    @Published var hasTimedOut = false
    private var timeoutTask: Task<Void, Never>?
    
    func startSession() {
        resetTimer()
    }
    
    func resetTimer() {
        timeoutTask?.cancel()
        timeoutTask = Task {
            do {
                try await Task.sleep(nanoseconds: 60_000_000_000)
                if !Task.isCancelled {
                    hasTimedOut = true // Triggers the alert popup
                }
            } catch { }
        }
    }
    
    func endSession() {
        timeoutTask?.cancel()
    }
}
