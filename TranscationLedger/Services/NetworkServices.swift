//
//  NetworkServices.swift
//  TranscationLedger
//
//  Created by ATEU on 2/21/26.
//

import Foundation

//MOCK API CALL
//class NetworkService {
//    // Simulating a RESTful API call
//    func fetchTransactions() async throws -> [Transaction] {
//        // In a real app, you would use URLSession like this:
//        // let url = URL(string: "https://api.bank.com/transactions")!
//        // let (data, _) = try await URLSession.shared.data(from: url)
//        // return try JSONDecoder().decode([Transaction].self, from: data)
//        
//        // Simulating a 2-second network delay to show the loading state
//        try await Task.sleep(nanoseconds: 2_000_000_000)
//        
//        // Returning mock JSON-like data
//        return [
//            Transaction(merchantName: "Apple Store", amount: -199.00, date: "2026-02-21"),
//            Transaction(merchantName: "Salary Deposit", amount: 4500.00, date: "2026-02-20"),
//            Transaction(merchantName: "Coffee Shop", amount: -4.50, date: "2026-02-19")
//        ]
//    }
//}


import Foundation

import Foundation

// This catches the raw JSON from the internet
struct TransactionDTO: Codable {
    let id: String
    let name: String
    let amount: Double
    let date: String
}

class NetworkService {
    func fetchTransactions() async throws -> [Transaction] {
        guard let url = URL(string: "https://mocki.io/v1/13d43a0b-cd98-4ebc-b8aa-b0ae57751a95") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        // 1. Decode the JSON into our simple DTO struct
        let downloadedData = try JSONDecoder().decode([TransactionDTO].self, from: data)
        
        // 2. Map (convert) the DTOs into our SwiftData database models
        return downloadedData.map { dto in
            Transaction(id: dto.id, merchantName: dto.name, amount: dto.amount, date: dto.date)
        }
    }
}
