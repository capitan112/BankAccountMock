//
//  TransactionDate.swift
//  BankAccountMock
//
//  Created by Oleksiy Chebotarov on 23/04/2025.
//

import SwiftUI

private struct TransactionDateFormatterKey: EnvironmentKey {
    static let defaultValue: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter
    }()
}

extension EnvironmentValues {
    var transactionDateFormatter: DateFormatter {
        get { self[TransactionDateFormatterKey.self] }
        set { self[TransactionDateFormatterKey.self] = newValue }
    }
}
