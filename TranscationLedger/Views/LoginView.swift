//
//  LoginView.swift
//  TranscationLedger
//
//  Created by ATEU on 2/23/26.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = AuthViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "building.columns.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.blue)
                .padding(.bottom, 20)
            
            Text("Welcome to CoreBank")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            VStack(spacing: 15) {
                TextField("Email", text: $viewModel.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                
                SecureField("Password", text: $viewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding(.horizontal, 30)
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            Button(action: {
                viewModel.login()
            }) {
                Text("Log In")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 30)
            .padding(.top, 10)
            
            Spacer()
        }
        .alert(isPresented: $viewModel.showAlert) {
                    Alert(
                        title: Text("Login Failed"),
                        message: Text(viewModel.alertMessage),
                        dismissButton: .default(Text("OK"))
                    )
                }
                .padding(.top, 50)
       
        // This is the magic router! If authentication succeeds, it covers the screen with our Ledger
        .fullScreenCover(isPresented: $viewModel.isAuthenticated) {
                    
                    // Extract "test" from "test@bank.com", capitalize it, or default to "User"
                    let extractedName = viewModel.email.components(separatedBy: "@").first?.capitalized ?? "User"
                    
                    TransactionListView(username: extractedName, onLogout: {
                        viewModel.logout() // This safely dismisses the screen
                    })
                }
    }
}
