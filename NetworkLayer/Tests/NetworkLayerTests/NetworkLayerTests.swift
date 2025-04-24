@testable import NetworkLayer
import XCTest

let jsonString = """
{
    "accounts": [
        {
            "id": 1,
            "accountNumber": "ACC000001",
            "name": "Account 1",
            "balance": 5148.72,
            "currency": "GBP"
        }
    ]
}
"""

class AccountsResponse: Codable {
    init(accounts: [Account]) {
        self.accounts = accounts
    }

    let accounts: [Account]
}

class Account: Codable, Identifiable, Hashable {
    init(id: Int, accountNumber: String, name: String, balance: Double, currency: String) {
        self.id = id
        self.accountNumber = accountNumber
        self.name = name
        self.balance = balance
        self.currency = currency
    }

    let id: Int
    let accountNumber: String
    let name: String
    let balance: Double
    let currency: String

    static func == (lhs: Account, rhs: Account) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

final class MockURLSession: URLSessionProtocol {
    var responseData: Data?
    var response: URLResponse?
    var error: Error?

    func data(for _: URLRequest) async throws -> (Data, URLResponse) {
        if let error = error {
            throw error
        }
        return (responseData ?? Data(), response ?? URLResponse())
    }
}

final class NetworkServiceTests: XCTestCase {
    var expectedModel: Account!
    var mockSession: MockURLSession!
    var mockResponse: HTTPURLResponse!

    override func setUp() {
        super.setUp()
        mockSession = MockURLSession()
        mockResponse = HTTPURLResponse(url: URL(string: "https://example.com")!,
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: nil)
        expectedModel = Account(
            id: 1,
            accountNumber: "ACC000001",
            name: "Account 1",
            balance: 5148.72,
            currency: "GBP"
        )
    }

    override func tearDown() {
        super.tearDown()
        expectedModel = nil
        mockSession = nil
        mockResponse = nil
    }

    func testFetch_successfulResponse_decodesAccount() async throws {
        let jsonData = jsonString.data(using: .utf8)!
        mockSession.responseData = jsonData
        mockSession.response = mockResponse

        let service = NetworkService(session: mockSession)
        let resource = NetworkResource<AccountsResponse>(url: APIEndpoint.accounts.url)
        let result = try await service.fetch(resource)

        XCTAssertEqual(result.accounts.first, expectedModel)
    }

    func testFetch_successfulResponse_decodesData() async throws {
        let mockSession = MockURLSession()

        mockSession.response = mockResponse
        let mockData = """
        {
          "accounts": [
           {
             "id": 1,
             "accountNumber": "ACC000001",
             "name": "Account 1",
             "balance": 5148.72,
             "currency": "GBP"
           }]
        }
        """.data(using: .utf8)!
        mockSession.responseData = mockData

        let service = NetworkService(session: mockSession)
        let resource = NetworkResource<AccountsResponse>(url: APIEndpoint.accounts.url)

        let result = try await service.fetch(resource)
        XCTAssertEqual(result.accounts.first, expectedModel)
    }

    func testFetch_invalidStatusCode_throwsError() async {
        let invalidResponse = HTTPURLResponse(
            url: URL(string: "https://example.com")!,
            statusCode: 404,
            httpVersion: nil,
            headerFields: nil
        )

        mockSession.response = invalidResponse
        mockSession.responseData = Data()

        let service = NetworkService(session: mockSession)
        let resource = NetworkResource<AccountsResponse>(url: APIEndpoint.accounts.url)

        do {
            _ = try await service.fetch(resource)
            XCTFail("Expected to throw error for invalid status code")
        } catch let error as NetworkError {
            switch error {
            case let .dataLoadingFailed(underlyingError as NetworkError):
                XCTAssertEqual(underlyingError, .responseError(404))
            default:
                XCTFail("Unexpected error: \(error)")
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
