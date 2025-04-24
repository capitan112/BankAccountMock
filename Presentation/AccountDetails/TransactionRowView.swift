//
//  TransactionRowView.swift
//  BankAccountMock
//
//  Created by Oleksiy Chebotarov on 23/04/2025.
//

import SwiftUI

struct TransactionRowView: View {
    let currency: String
    let transaction: Transaction
    @Environment(\.transactionDateFormatter) var dateFormatter: DateFormatter

    var isPaymentOrDeposit: Bool {
        transaction.description.localizedCaseInsensitiveContains("payment") || transaction.description.localizedCaseInsensitiveContains("deposit")
    }

    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .frame(width: 35, height: 35)
                    .opacity(0.15)
                Image(systemName: isPaymentOrDeposit ? "arrow.down.circle.fill" : "arrow.up.circle.fill")
            }
            .foregroundColor(isPaymentOrDeposit ? .green : .red)

            LazyVStack(alignment: .leading) {
                Text(transaction.description)
                    .font(.headline)
                    .fontWeight(.medium)
                if let date = dateFormatter.date(from: transaction.date) {
                    Text(date, format: .dateTime.day().month(.wide).year())
                        .font(.caption)
                        .foregroundColor(.secondary)
                } else {
                    Text("Invalid Date")
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }
            Spacer()
            Text(transaction.amount, format: .currency(code: currency))
                .font(.headline)
                .fontWeight(.medium)
                .foregroundColor(transaction.amount > 0 ? .green : .red)
        }
        .padding(.vertical, 4)
    }
}
