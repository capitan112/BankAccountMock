//
//  AccountDetailsLoadedView.swift
//  BankAccountMock
//
//  Created by Oleksiy Chebotarov on 23/04/2025.
//

import SwiftUI

struct AccountDetailsLoadedView: View {
    @StateObject var viewModel: AccountsDetailViewModel
    @Environment(\.colorScheme) private var colorScheme
    @State private var viewId = UUID()

    private var appColors: AppColors {
        AppColors(colorScheme: colorScheme)
    }

    init(account: Account) {
        _viewModel = StateObject(wrappedValue: AccountsDetailViewModel(account: account))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                accountHeader
                Divider()
                accountDetails(currency: viewModel.account.currency)
            }
            .padding()
            .frame(maxWidth: .infinity)
        }
        .navigationTitle("Account Details")
        .onAppear {
            Task {
                await viewModel.fetchAccountDetail()
            }
        }
        .id(viewId)
        .onChange(of: colorScheme) {
            viewId = UUID()
            viewModel.loadingState = .initial
            Task {
                await viewModel.fetchAccountDetail()
            }
        }
    }

    // MARK: - Account Header

    private var accountHeader: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(viewModel.account.name)
                .font(.title)
                .fontWeight(.bold)
                .accessibilityLabel("Account Name: \(viewModel.account.name)")
                .accessibilityIdentifier("accountName")

            Text(viewModel.account.accountNumber)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .accessibilityLabel("Account Number: \(viewModel.account.accountNumber)")
                .accessibilityIdentifier("accountNumber")

            HStack(alignment: .firstTextBaseline) {
                Text("Balance")
                    .font(.headline)
                    .accessibilityLabel("Balance")

                Spacer()

                Text(viewModel.account.balance, format: .currency(code: viewModel.account.currency))
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(viewModel.account.balance >= 0 ? .green : .red)
                    .accessibilityLabel("Current Balance: \(viewModel.account.balance, format: .currency(code: viewModel.account.currency))")
                    .accessibilityIdentifier("accountBalance")
            }
            .padding(.top, 8)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(appColors.primary)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Account Information")
        )
    }

    private func accountDetails(currency: String) -> some View {
        Group {
            switch viewModel.loadingState {
            case .initial, .loading:
                VStack {
                    Spacer(minLength: 200)
                    ProgressView()
                        .accessibilityLabel("Loading account details")
                }
                .frame(maxWidth: .infinity)
            case let .loaded(details):
                VStack(alignment: .leading) {
                    accountOwnerSection(owner: details.owner)
                        .padding(.bottom, 12)
                    Divider()
                    recentTransactionsSection(currency: currency, transactions: details.transactions)
                }
            case let .error(errorMessage):
                AccountsErrorView(errorMessage: errorMessage) {
                    Task {
                        await viewModel.fetchAccountDetail()
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
    }

    private func accountOwnerSection(owner: Owner) -> some View {
        VStack(alignment: .leading) {
            Text("Account Owner")
                .sectionTitleStyle()
                .accessibilityLabel("Account Owner")
                .accessibilityIdentifier("accountOwnerTitle")
            HStack {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 35, height: 35)
                    .foregroundColor(.blue)
                    .accessibilityLabel("Account owner icon")
                    .accessibilityIdentifier("accountOwnerIcon")
                VStack(alignment: .leading) {
                    Text(owner.name)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .accessibilityLabel("Owner Name: \(owner.name)")
                        .accessibilityIdentifier("ownerName")
                    Text(owner.email)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .accessibilityLabel("Owner Email: \(owner.email)")
                        .accessibilityIdentifier("ownerEmail")
                }
            }
            .padding()
            .background(appColors.background)
            .cornerRadius(12)
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Account Owner Information")
        }
    }

    // MARK: - Recent Transactions Section

    private func recentTransactionsSection(currency: String, transactions: [Transaction]) -> some View {
        VStack(alignment: .leading) {
            Text("Recent Transactions")
                .sectionTitleStyle()
                .accessibilityLabel("Recent Transactions")
                .accessibilityIdentifier("recentTransactionsTitle")
            ForEach(transactions) { transaction in
                TransactionRowView(currency: currency, transaction: transaction)
                    .padding()
                    .background(appColors.background)
                    .cornerRadius(8)
                    .padding(.bottom, 4)
            }
        }
    }
}

struct SectionTitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .padding(.bottom, 8)
    }
}

extension View {
    func sectionTitleStyle() -> some View {
        modifier(SectionTitleModifier())
    }
}

#Preview {
    AccountDetailsLoadedView(account: Account(id: 1, accountNumber: "1234567890", name: "John Doe", balance: 100.0, currency: "GBP"))
}
