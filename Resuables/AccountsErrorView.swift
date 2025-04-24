//
//  AccountsErrorView.swift
//  BankAccountMock
//
//  Created by Oleksiy Chebotarov on 23/04/2025.
//

import SwiftUI

struct AccountsErrorView: View {
    let errorMessage: String
    let retryTapped: () -> Void

    var body: some View {
        VStack {
            Text(errorMessage)
            Button("Retry") {
                retryTapped()
            }.buttonStyle(.bordered)
        }
        .padding()
    }
}
