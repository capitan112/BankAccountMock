//
//  AccountsDetailViewModel.swift
//  BankAccountMock
//
//  Created by Oleksiy Chebotarov on 23/04/2025.
//

import Foundation

final class AccountsDetailViewModel: ObservableObject {
    let account: Account
    @Published var loadingState: LoadingStage<AccountDetail> = .initial
    private let accountsDetailsService: AccountDetailsServiceProtocol

    init(account: Account, loadingStage: LoadingStage<AccountDetail> = .initial, accountsDetailsService: AccountDetailsServiceProtocol = AccountDetailsService()) {
        self.account = account
        loadingState = loadingStage
        self.accountsDetailsService = accountsDetailsService
    }

    @MainActor
    func fetchAccountDetail() async {
        loadingState = .loading
        do {
            let accounts = try await accountsDetailsService.execute(for: account)
            loadingState = .loaded(accounts)
        } catch {
            loadingState = .error("Unknown Error, please try again later.")
        }
    }
}
