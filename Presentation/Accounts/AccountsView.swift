//
//  AccountsView.swift
//  BankAccountMock
//
//  Created by Oleksiy Chebotarov on 23/04/2025.
//

import SwiftUI

struct AccountsView: View {
    @EnvironmentObject var viewModel: AccountsViewModel

    var body: some View {
        Group {
            switch viewModel.loadingStage {
            case .initial, .loading:
                ProgressView()
            case let .loaded(accounts):
                AccountsLoadedView(viewModel: AccountsLoadedViewModel(accounts: accounts))
            case let .error(errorMessage):
                AccountsErrorView(errorMessage: errorMessage) {
                    Task {
                        await viewModel.fetchAccounts()
                    }
                }
            }
        }
        .refreshable {
            viewModel.loadingStage = .initial
            Task {
                await viewModel.fetchAccounts()
            }
        }
        .navigationTitle("Accounts")
        .onAppear {
            Task {
                await viewModel.fetchAccounts()
            }
        }
    }

    private func fetchAccounts() {
        Task {
            await viewModel.fetchAccounts()
        }
    }
}

extension Account {
    var accessibilityLabel: String {
        "\(name) - \(balance.formatted(.currency(code: currency)))"
    }
}

#Preview {
    ContentView()
}
