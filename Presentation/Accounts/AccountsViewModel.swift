//
//  AccountsViewModel.swift
//  BankAccountMock
//
//  Created by Oleksiy Chebotarov on 23/04/2025.
//

import Foundation
import SwiftUI

final class AccountsViewModel: ObservableObject {
    @Published var loadingStage: LoadingStage<[Account]>
    let accountsService: AccountsServiceProtocol

    init(accountsService: AccountsServiceProtocol = AccountsService(), loadingStage: LoadingStage<[Account]> = .initial,) {
        self.accountsService = accountsService
        self.loadingStage = loadingStage
    }

    @MainActor
    func fetchAccounts() async {
        if case .initial = loadingStage {
            loadingStage = .loading
            do {
                let accounts = try await accountsService.execute()
                loadingStage = .loaded(accounts)
            } catch {
                loadingStage = .error(error.localizedDescription)
            }
        }
    }
}
