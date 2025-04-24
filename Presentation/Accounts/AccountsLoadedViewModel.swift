//
//  AccountsLoadedViewModel.swift
//  BankAccountMock
//
//  Created by Oleksiy Chebotarov on 23/04/2025.
//

import SwiftUI

final class AccountsLoadedViewModel: ObservableObject {
    @Published var searchText: String
    let accounts: [Account]

    init(searchText: String = "", accounts: [Account]) {
        self.searchText = searchText
        self.accounts = accounts
    }

    var filteredAccounts: [Account] {
        if searchText.isEmpty {
            return accounts
        } else {
            return accounts.filter { account in
                let nameMatch = account.name.localizedCaseInsensitiveContains(searchText)
                let balanceMatch = String(format: "%.2f", account.balance).localizedCaseInsensitiveContains(searchText)
                return nameMatch || balanceMatch
            }
        }
    }
}
