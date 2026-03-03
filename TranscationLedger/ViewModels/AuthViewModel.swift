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
    @AppStorage("userMPIN") var storedMPIN: String = "" // Simulates a backend save
    
    @Published var enteredMPIN = ""
    @Published var newMPIN = ""
    @Published var confirmMPIN = ""
    
    @Published var isAuthenticated = false
    @Published var hasRegistered = false
    @Published var errorMessage: String?
    
    // Lockout States
    @Published var showAlert = false
    @Published var alertMessage = ""
    private var failedAttempts = 0
    private var lockoutExpiry: Date?
    
    init() {
        hasRegistered = !storedMPIN.isEmpty // Check if an MPIN is already set!
    }
    
    // --- Registration Flow ---
    func registerUser() {
        guard newMPIN.count == 6, confirmMPIN.count == 6 else {
            errorMessage = "MPIN must be 6 digits."
            return
        }
        
        if newMPIN == confirmMPIN {
            storedMPIN = newMPIN // Save it to device storage!
            hasRegistered = true
            errorMessage = nil
            // Clear fields for security
            newMPIN = ""
            confirmMPIN = ""
        } else {
            errorMessage = "MPINs do not match. Please try again."
        }
    }
    
    // --- Login Flow ---
    func login() {
        if let expiry = lockoutExpiry {
            if Date() < expiry {
                alertMessage = "Too many attempts. Try again later."
                showAlert = true
                return
            } else {
                failedAttempts = 0
                lockoutExpiry = nil
            }
        }
        
        if enteredMPIN == storedMPIN && !enteredMPIN.isEmpty {
            isAuthenticated = true
            errorMessage = nil
            failedAttempts = 0
            enteredMPIN = "" // Clear after success
        } else {
            failedAttempts += 1
            if failedAttempts == 2 {
                alertMessage = "Only one attempt left!"
                showAlert = true
            } else if failedAttempts >= 3 {
                lockoutExpiry = Date().addingTimeInterval(120)
                alertMessage = "Too many attempts. Try again later."
                showAlert = true
            } else {
                errorMessage = "Invalid MPIN."
            }
            isAuthenticated = false
        }
    }
    
    func logout() {
        isAuthenticated = false
        enteredMPIN = ""
    }
}
