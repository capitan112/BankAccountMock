//
//  AccountsLoadedViewModelTests.swift
//  BankAccountMockTests
//
//  Created by Oleksiy Chebotarov on 23/04/2025.
//

@testable import BankAccountMock
import XCTest

final class AccountsLoadedViewModelTests: XCTestCase {
    var accounts: [Account]!

    override func setUp() {
        super.setUp()
        accounts = [
            Account(id: 1, accountNumber: "123", name: "Alpha Account", balance: 100.00, currency: "GBP"),
            Account(id: 2, accountNumber: "456", name: "Beta Account", balance: 200.50, currency: "USD"),
            Account(id: 3, accountNumber: "789", name: "Gamma Account", balance: 150.75, currency: "EUR"),
            Account(id: 4, accountNumber: "012", name: "Alpha Beta", balance: 100.01, currency: "GBP"),
        ]
    }

    override func tearDown() {
        accounts = nil
        super.tearDown()
    }

    func testInit_setsInitialSearchTextAndAccounts() {
        let viewModel = AccountsLoadedViewModel(searchText: "test", accounts: accounts)
        XCTAssertEqual(viewModel.searchText, "test")
        XCTAssertEqual(viewModel.accounts, accounts)
    }

    func testFilteredAccounts_whenSearchTextIsEmpty_returnsAllAccounts() {
        let viewModel = AccountsLoadedViewModel(searchText: "", accounts: accounts)
        XCTAssertEqual(viewModel.filteredAccounts, accounts)
    }

    func testFilteredAccounts_whenSearchTextMatchesName_returnsMatchingAccounts() {
        let viewModel = AccountsLoadedViewModel(searchText: "alpha", accounts: accounts)
        let expectedAccounts = [accounts[0], accounts[3]]
        XCTAssertEqual(viewModel.filteredAccounts, expectedAccounts)
    }

    func testFilteredAccounts_whenSearchTextMatchesNameCaseInsensitive_returnsMatchingAccounts() {
        let viewModel = AccountsLoadedViewModel(searchText: "BETA", accounts: accounts)
        let expectedAccounts = [accounts[1], accounts[3]]
        XCTAssertEqual(viewModel.filteredAccounts, expectedAccounts)
    }

    func testFilteredAccounts_whenSearchTextMatchesPartialName_returnsMatchingAccounts() {
        let viewModel = AccountsLoadedViewModel(searchText: "acc", accounts: accounts)
        XCTAssertEqual(viewModel.filteredAccounts.count, 3)
    }

    func testFilteredAccounts_whenSearchTextMatchesBalance_returnsMatchingAccounts() {
        let viewModel = AccountsLoadedViewModel(searchText: "100.00", accounts: accounts)
        let expectedAccounts = [accounts[0]]
        XCTAssertEqual(viewModel.filteredAccounts, expectedAccounts)
    }

    func testFilteredAccounts_whenSearchTextMatchesPartialBalance_returnsMatchingAccounts() {
        let viewModel = AccountsLoadedViewModel(searchText: "200", accounts: accounts)
        let expectedAccounts = [accounts[1]]
        XCTAssertEqual(viewModel.filteredAccounts, expectedAccounts)
    }

    func testFilteredAccounts_whenSearchTextMatchesBalanceWithDecimal_returnsMatchingAccounts() {
        let viewModel = AccountsLoadedViewModel(searchText: "150.75", accounts: accounts)
        let expectedAccounts = [accounts[2]]
        XCTAssertEqual(viewModel.filteredAccounts, expectedAccounts)
    }

    func testFilteredAccounts_whenSearchTextMatchesNameOrBalance_returnsMatchingAccounts() {
        let viewModel = AccountsLoadedViewModel(searchText: "beta", accounts: accounts)
        let expectedAccounts = [accounts[1], accounts[3]]
        XCTAssertEqual(viewModel.filteredAccounts.sorted(by: { $0.id < $1.id }), expectedAccounts.sorted(by: { $0.id < $1.id }))
    }

    func testFilteredAccounts_whenSearchTextDoesNotMatch_returnsEmptyArray() {
        let viewModel = AccountsLoadedViewModel(searchText: "nonexistent", accounts: accounts)
        XCTAssertTrue(viewModel.filteredAccounts.isEmpty)
    }
}
