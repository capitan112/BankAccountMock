//
//  AccountSummaryView.swift
//  BankAccountMock
//
//  Created by Oleksiy Chebotarov on 23/04/2025.
//

import SwiftUI

struct AccountSummaryView: View {
    let account: Account
    @Environment(\.colorScheme) private var colorScheme

    private var appColors: AppColors {
        AppColors(colorScheme: colorScheme)
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(account.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(appColors.textColor)

                Text(account.accountNumber)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text(account.balance, format: .currency(code: account.currency))
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(account.balance >= 0 ? .green : .red)

                Text(account.currency)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
    }
}

#Preview {
    AccountSummaryView(account: Account(id: 1, accountNumber: "1234567890", name: "John Doe", balance: 100.0, currency: "GBP"))
}
