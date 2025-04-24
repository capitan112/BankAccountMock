//
//  AccountDetailsTest.swift
//  BankAccountMockTests
//
//  Created by Oleksiy Chebotarov on 23/04/2025.
//
@testable import BankAccountMock
import Combine
import XCTest

final class MockAccountDetailsService: AccountDetailsServiceProtocol {
    var result: Result<AccountDetail, Error>

    init(result: Result<AccountDetail, Error>) {
        self.result = result
    }

    func execute(for _: Account) async throws -> AccountDetail {
        switch result {
        case let .success(detail):
            return detail
        case let .failure(error):
            throw error
        }
    }
}

final class AccountServiceDetailsTest: XCTestCase {
    var mockAccount: Account!
    var mockAccountDetail: AccountDetail!
    var mockService: AccountDetailsServiceProtocol!

    override func setUp() {
        mockAccount = Account(id: 1, accountNumber: "ACC000001", name: "John Doe", balance: 100.0, currency: "GBP")
        mockAccountDetail = AccountDetail(
            id: 1,
            accountNumber: "ACC000001",
            name: "Josh",
            balance: 10.0,
            currency: "pounds",
            owner: Owner(name: "Josh", email: "ggg@gmail.com"),
            transactions: [Transaction(id: "100", date: "Date", description: "description", amount: 5.0)]
        )

        mockService = MockAccountDetailsService(result: .success(mockAccountDetail))
        super.setUp()
    }

    override func tearDown() {
        mockAccount = nil
        mockAccountDetail = nil
        mockService = nil
        super.tearDown()
    }

    func testAccountDetailsSuccessfully() async {
        let accountDetailsUseCase = AccountDetailsService()

        do {
            let result = try await accountDetailsUseCase.execute(for: mockAccount)
            XCTAssertTrue(result.id == 1)
        } catch {
            XCTFail("Failed to get accounts: \(error)")
        }
    }

    func testInit_setsAccountAndInitialLoadingState() {
        let viewModel = AccountsDetailViewModel(account: mockAccount)
        XCTAssertEqual(viewModel.account, mockAccount)
        if case .initial = viewModel.loadingState {
            XCTAssert(true)
        } else {
            XCTFail()
        }
    }

    func testFetchAccountDetail_setsLoadingStateToLoading() async {
        let viewModel = AccountsDetailViewModel(account: mockAccount, accountsDetailsService: mockService)
        let expectation = expectation(description: "Loading state should be set to loading")

        var states: [LoadingStage<AccountDetail>] = []
        let cancellable = viewModel.$loadingState
            .sink { state in
                states.append(state)
                if case .loading = state {
                    expectation.fulfill()
                }
            }

        await viewModel.fetchAccountDetail()
        await fulfillment(of: [expectation], timeout: 1.0)
        cancellable.cancel()

        XCTAssertTrue(states.contains { if case .loading = $0 { return true } else { return false } })
    }

    func testFetchAccountDetail_onSuccess_setsLoadingStateToLoadedWithDetails() async {
        let viewModel = AccountsDetailViewModel(account: mockAccount, accountsDetailsService: mockService)
        await viewModel.fetchAccountDetail()

        if case let .loaded(detail) = viewModel.loadingState {
            XCTAssertEqual(detail.accountNumber, mockAccountDetail.accountNumber)
        } else {
            XCTFail("Loading state should be .loaded")
        }
    }

    func testFetchAccountDetail_onFailure_setsLoadingStateToError() async {
        let mockError = NSError(domain: "TestError", code: 123)
        let mockService = MockAccountDetailsService(result: .failure(mockError))
        let viewModel = AccountsDetailViewModel(account: mockAccount, accountsDetailsService: mockService)

        await viewModel.fetchAccountDetail()

        if case let .error(message) = viewModel.loadingState {
            XCTAssertEqual(message, "Unknown Error, please try again later.")
        } else {
            XCTFail("Loading state should be .error")
        }
    }
}
