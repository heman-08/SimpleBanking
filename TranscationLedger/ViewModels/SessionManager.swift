//
//  SessionManager.swift
//  TranscationLedger
//
//  Created by ATEU on 2/23/26.
//


import Foundation
import SwiftUI
import Combine

@MainActor
class SessionManager: ObservableObject {
    @Published var isLoggedOut = false
    private var timeoutTask: Task<Void, Never>?
    
    func startSession() {
        resetTimer()
    }
    
    // Call this every time the user taps or scrolls
    func resetTimer() {
        // 1. Cancel the previous countdown
        timeoutTask?.cancel()
        
        // 2. Start a brand new 60-second countdown
        timeoutTask = Task {
            do {
                // Task.sleep pauses the background task for 60 seconds
                try await Task.sleep(nanoseconds: 60_000_000_000)
                
                // 3. If the 60 seconds finish and the task wasn't cancelled, log them out!
                if !Task.isCancelled {
                    isLoggedOut = true
                }
            } catch {
                // If the timer is cancelled (because the user touched the screen),
                // it throws an error and safely stops here.
            }
        }
    }
    
    func endSession() {
        timeoutTask?.cancel()
        isLoggedOut = true
    }
}
