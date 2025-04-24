//
//  ContentView.swift
//  BankAccountMock
//
//  Created by Oleksiy Chebotarov on 23/04/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            AccountsView()
        }
        .environmentObject(AccountsViewModel())
    }
}

#Preview {
    ContentView()
}
