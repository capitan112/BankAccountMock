//
//  AccountsLoadedView.swift
//  BankAccountMock
//
//  Created by Oleksiy Chebotarov on 23/04/2025.
//

import SwiftUI

struct AccountsLoadedView: View {
    @ObservedObject var viewModel: AccountsLoadedViewModel
    @Environment(\.colorScheme) private var colorScheme

    private var appColors: AppColors {
        AppColors(colorScheme: colorScheme)
    }

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.filteredAccounts, id: \.id) { account in
                    NavigationLink(destination: AccountDetailsLoadedView(account: account)) {
                        AccountSummaryView(account: account)
                            .accessibilityIdentifier(account.accessibilityLabel)
                    }
                    if let last = viewModel.filteredAccounts.last, last != account {
                        Divider()
                            .background(appColors.secondary)
                            .padding(.horizontal)
                    }
                }
            }
        }
        .searchable(text: $viewModel.searchText, prompt: "Search accounts")
        .overlay {
            if viewModel.filteredAccounts.isEmpty && !viewModel.searchText.isEmpty {
                ContentUnavailableView.search(text: viewModel.searchText)
            }
        }
    }
}
