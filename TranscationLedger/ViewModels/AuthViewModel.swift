//
//  AuthViewModel.swift
//  TranscationLedger
//
//  Created by ATEU on 2/23/26.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class AuthViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isAuthenticated = false
    @Published var errorMessage: String?
    
    // NEW: Lockout Tracking
    @Published var showAlert = false
    @Published var alertMessage = ""
    private var failedAttempts = 0
    private var lockoutExpiry: Date?
    
    private let testEmail = "test@bank.com"
    private let testPassword = "password123"
    
    func login() {
        // 1. Check if the user is currently locked out
        if let expiry = lockoutExpiry {
            if Date() < expiry {
                alertMessage = "Too many attempts. Try again later."
                showAlert = true
                return
            } else {
                // Time has passed, unlock the account
                failedAttempts = 0
                lockoutExpiry = nil
            }
        }
        
        // 2. Attempt Login
        if email.lowercased() == testEmail && password == testPassword {
            isAuthenticated = true
            errorMessage = nil
            failedAttempts = 0 // Reset on success
        } else {
            failedAttempts += 1
            
            // 3. Handle Failures
            if failedAttempts == 2 {
                alertMessage = "Only one attempt left!"
                showAlert = true
            } else if failedAttempts >= 3 {
                lockoutExpiry = Date().addingTimeInterval(120) // 120 seconds = 2 minutes
                alertMessage = "Too many attempts. Try again later."
                showAlert = true
            } else {
                errorMessage = "Invalid email or password."
            }
            isAuthenticated = false
        }
    }
    
    func logout() {
        isAuthenticated = false
        email = ""
        password = ""
    }
}
