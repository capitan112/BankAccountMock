//
//  AccountsServiceTest.swift
//  BankAccountMockTests
//
//  Created by Oleksiy Chebotarov on 24/04/2025.
//

@testable import BankAccountMock
import Combine
import XCTest

final class MockAccountsService: AccountsServiceProtocol {
    var result: Result<[Account], Error>

    init(result: Result<[Account], Error>) {
        self.result = result
    }

    func execute() async throws -> [Account] {
        switch result {
        case let .success(accounts):
            return accounts
        case let .failure(error):
            throw error
        }
    }
}

final class AccountsServiceTest: XCTestCase {
    var mockAccounts: [Account]!
    var mockAccountService: MockAccountsService!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockAccounts = [
            Account(id: 1, accountNumber: "123", name: "Account 1", balance: 100.0, currency: "GBP"),
            Account(id: 2, accountNumber: "456", name: "Account 2", balance: 200.0, currency: "USD"),
        ]
        cancellables = []
    }

    override func tearDown() {
        mockAccounts = nil
        cancellables = nil
        super.tearDown()
    }

    func testGetAccountsSuccessfully() async {
        let accountsService = AccountsService()

        do {
            let result = try await accountsService.execute()
            XCTAssertTrue(result.count > 0)
            XCTAssertTrue(result.first?.name != "")
        } catch {
            XCTFail("Failed to get accounts: \(error)")
        }
    }

    func testInit_setsInitialLoadingStage() {
        let viewModel = AccountsViewModel()
        if case .initial = viewModel.loadingStage {
            XCTAssert(true)
        } else {
            XCTFail("Initial state should be .initial")
        }
    }

    func testFetchAccounts_setsLoadingStageToLoading() async {
        mockAccountService = MockAccountsService(result: .success(mockAccounts))
        let viewModel = AccountsViewModel(accountsService: mockAccountService)

        let expectation = expectation(description: "Loading stage should be set to loading")

        var states: [LoadingStage<[Account]>] = []
        viewModel.$loadingStage
            .sink { stage in
                states.append(stage)
                if case .loading = stage {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        await viewModel.fetchAccounts()
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertTrue(states.contains { if case .loading = $0 { return true } else { return false } })
    }

    func testFetchAccounts_onSuccess_setsLoadingStageToLoadedWithAccounts() async {
        mockAccountService = MockAccountsService(result: .success(mockAccounts))
        let viewModel = AccountsViewModel(accountsService: mockAccountService)

        await viewModel.fetchAccounts()

        if case let .loaded(accounts) = viewModel.loadingStage {
            XCTAssertEqual(accounts, mockAccounts)
        } else {
            XCTFail("Loading stage should be .loaded")
        }
    }

    func testFetchAccounts_onFailure_setsLoadingStageToError() async {
        let mockError = NSError(domain: "TestError", code: 123)
        mockAccountService = MockAccountsService(result: .failure(mockError))
        let viewModel = AccountsViewModel(accountsService: mockAccountService)

        await viewModel.fetchAccounts()

        if case let .error(message) = viewModel.loadingStage {
            XCTAssertEqual(message, mockError.localizedDescription)
        } else {
            XCTFail("Loading stage should be .error")
        }
    }

    func testFetchAccounts_whenAlreadyLoaded_doesNotFetchAgain() async {
        mockAccountService = MockAccountsService(result: .success(mockAccounts))
        let viewModel = AccountsViewModel(accountsService: mockAccountService)

        viewModel.loadingStage = .loaded(mockAccounts)

        await viewModel.fetchAccounts()

        if case let .loaded(accounts) = viewModel.loadingStage {
            XCTAssertEqual(accounts, mockAccounts)
        } else {
            XCTFail("Loading stage should remain .loaded")
        }
    }
}
