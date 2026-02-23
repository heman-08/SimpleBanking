//
//  Transcation.swift
//  TranscationLedger
//
//  Created by ATEU on 2/21/26.
//

import Foundation
import SwiftData

@Model
class Transaction: Identifiable {
    @Attribute(.unique) var id: String // Ensures no duplicate transactions
    var merchantName: String
    var amount: Double
    var date: String
    
    init(id: String = UUID().uuidString, merchantName: String, amount: Double, date: String) {
        self.id = id
        self.merchantName = merchantName
        self.amount = amount
        self.date = date
    }
}
