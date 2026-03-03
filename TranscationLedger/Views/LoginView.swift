//
//  LoginView.swift
//  TranscationLedger
//
//  Created by ATEU on 2/23/26.
//

import SwiftUI

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = AuthViewModel()
    
    var body: some View {
        Group {
            if viewModel.hasRegistered {
                // If they have an MPIN, show Login
                MPINLoginScreen(viewModel: viewModel)
            } else {
                // If no MPIN exists, show Registration
                MPINRegistrationScreen(viewModel: viewModel)
            }
        }
        .fullScreenCover(isPresented: $viewModel.isAuthenticated) {
            // Hardcode username since we removed email
            TransactionListView(username: "User", onLogout: {
                viewModel.logout()
            })
        }
    }
}

struct MPINRegistrationScreen: View {
    @ObservedObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Set Up CoreBank")
                .font(.largeTitle).fontWeight(.bold)
            
            Text("Please create a 6-digit MPIN to secure your account.")
                .font(.subheadline).foregroundColor(.secondary).multilineTextAlignment(.center).padding(.horizontal)
            
            VStack(spacing: 15) {
                SecureField("Enter 6-Digit MPIN", text: $viewModel.newMPIN)
                    .keyboardType(.numberPad) // Numbers only!
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                SecureField("Confirm MPIN", text: $viewModel.confirmMPIN)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding(.horizontal, 40)
            
            if let error = viewModel.errorMessage {
                Text(error).foregroundColor(.red).font(.caption)
            }
            
            Button("Register MPIN") {
                viewModel.registerUser()
            }
            .frame(maxWidth: .infinity).padding().background(Color.blue).foregroundColor(.white).cornerRadius(10)
            .padding(.horizontal, 40)
            
            Spacer()
        }
        .padding(.top, 50)
    }
}

struct MPINLoginScreen: View {
    @ObservedObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "lock.shield.fill")
                .resizable().scaledToFit().frame(width: 80, height: 80).foregroundColor(.blue).padding(.bottom, 20)
            
            Text("Welcome Back")
                .font(.largeTitle).fontWeight(.bold)
            
            SecureField("Enter MPIN", text: $viewModel.enteredMPIN)
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 60)
            
            if let error = viewModel.errorMessage {
                Text(error).foregroundColor(.red).font(.caption)
            }
            
            Button("Log In") {
                viewModel.login()
            }
            .frame(maxWidth: .infinity).padding().background(Color.blue).foregroundColor(.white).cornerRadius(10)
            .padding(.horizontal, 60)
            
            // --- The "Forgot" Placeholder ---
            Button(action: {
                // Action to be coded later!
                print("Forgot MPIN clicked")
            }) {
                Text("Forgot MPIN?")
                    .font(.footnote)
                    .foregroundColor(.blue)
            }
            .padding(.top, 10)
            
            Spacer()
        }
        .padding(.top, 50)
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Security Alert"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}
