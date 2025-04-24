//
//  AccountDetail.swift
//  BankAccountMock
//
//  Created by Oleksiy Chebotarov on 23/04/2025.
//

import Foundation

struct AccountDetail: Codable, Identifiable {
    let id: Int
    let accountNumber, name: String
    let balance: Double
    let currency: String
    let owner: Owner
    let transactions: [Transaction]
}

// MARK: - Owner

struct Owner: Codable {
    let name, email: String
}

// MARK: - Transaction

struct Transaction: Codable, Identifiable {
    let id, date, description: String
    let amount: Double
}
