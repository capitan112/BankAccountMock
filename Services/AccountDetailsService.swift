//
//  AccountDetailsService.swift
//  BankAccountMock
//
//  Created by Oleksiy Chebotarov on 23/04/2025.
//

import Foundation
import NetworkLayer

protocol AccountDetailsServiceProtocol {
    func execute(for account: Account) async throws -> AccountDetail
}

class AccountDetailsService: AccountDetailsServiceProtocol {
    private let networkService: NetworkServiceProtocol
    private let remoteAccount: String = "ACC000001"

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }

    func execute(for account: Account) async throws -> AccountDetail {
        if remoteAccount == account.accountNumber {
            let resource = NetworkResource<AccountDetail>(url: APIEndpoint.accountDetails(id: account.id).url)
            do {
                return try await networkService.fetch(resource)
            } catch let error as NetworkError {
                throw error
            } catch {
                throw NetworkError.dataLoadingFailed(error)
            }
        } else {
            return generateAccountDetail(forAccountNumber: account.accountNumber)
        }
    }

    private func generateAccountDetail(forAccountNumber accountNumber: String) -> AccountDetail {
        let seed = abs(accountNumber.hashValue)
        var randomNumberGenerator = SeededRandomNumberGenerator(seed: UInt64(seed))

        let id = abs(seed) % 1000 + 1

        let firstName = ["Alice", "Bob", "Charlie", "David", "Eve"].randomElement(using: &randomNumberGenerator)!
        let lastName = ["Smith", "Jones", "Williams", "Brown", "Davis"].randomElement(using: &randomNumberGenerator)!
        let ownerName = "\(firstName) \(lastName)"
        let ownerEmail = "\(firstName.lowercased()).\(lastName.lowercased())@example.com"
        let owner = Owner(name: ownerName, email: ownerEmail)

        let balance = Double.random(in: 1000.0 ... 10000.0, using: &randomNumberGenerator).rounded(toPlaces: 2)

        var transactions: [Transaction] = []
        let numberOfTransactions = Int.random(in: 3 ... 7, using: &randomNumberGenerator)
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let now = Date()

        for i in 0 ..< numberOfTransactions {
            let transactionId = UUID().uuidString.prefix(8).uppercased() + String(i + 1)
            let daysAgo = Int.random(in: 1 ... 30, using: &randomNumberGenerator)
            let transactionDate = Calendar.current.date(byAdding: .day, value: -daysAgo, to: now)!
            let formattedDateString = dateFormatter.string(from: transactionDate)
            let descriptionOptions = ["Payment", "Withdrawal", "Deposit", "Transfer", "Purchase"]
            let description = descriptionOptions.randomElement(using: &randomNumberGenerator)!
            var amount = Double.random(in: -500.0 ... 500.0, using: &randomNumberGenerator).rounded(toPlaces: 2)

            switch description {
            case "Deposit", "Payment":
                amount = abs(amount > 0 ? amount : Double.random(in: 1.0 ... 500.0, using: &randomNumberGenerator).rounded(toPlaces: 2))
            case "Withdrawal", "Purchase", "Transfer":
                amount = -abs(amount > 0 ? amount : Double.random(in: 1.0 ... 500.0, using: &randomNumberGenerator).rounded(toPlaces: 2))
            default:
                amount = amount.rounded(toPlaces: 2)
            }

            transactions.append(Transaction(id: transactionId, date: formattedDateString, description: description, amount: amount))
        }

        return AccountDetail(id: id, accountNumber: accountNumber, name: "Account \(id)", balance: balance, currency: "GBP", owner: owner, transactions: transactions)
    }
}

extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
