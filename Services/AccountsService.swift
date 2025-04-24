//
//  AccountsService.swift
//  BankAccountMock
//
//  Created by Oleksiy Chebotarov on 23/04/2025.
//

import Foundation
import NetworkLayer

protocol AccountsServiceProtocol {
    func execute() async throws -> [Account]
}

class AccountsService: AccountsServiceProtocol {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }

    func execute() async throws -> [Account] {
        let resource = NetworkResource<Accounts>(url: APIEndpoint.accounts.url)
        do {
            let result = try await networkService.fetch(resource)
            return result.accounts
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.dataLoadingFailed(error)
        }
    }
}
