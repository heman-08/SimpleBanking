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
    
    // We use a hardcoded test user to simulate a backend database
    private let testEmail = "test@bank.com"
    private let testPassword = "password123"
    
    func login() {
        // Validate user
        if email.lowercased() == testEmail && password == testPassword {
            isAuthenticated = true
            errorMessage = nil
        } else {
            errorMessage = "Invalid email or password."
            isAuthenticated = false
        }
    }
    
    func logout() {
        isAuthenticated = false
        email = ""
        password = ""
    }
}
