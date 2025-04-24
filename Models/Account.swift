//
//  Account.swift
//  BankAccountMock
//
//  Created by Oleksiy Chebotarov on 23/04/2025.
//

import Foundation

struct Accounts: Codable {
    let accounts: [Account]
}

struct Account: Codable, Identifiable, Hashable {
    let id: Int
    let accountNumber: String
    let name: String
    let balance: Double
    let currency: String
}
