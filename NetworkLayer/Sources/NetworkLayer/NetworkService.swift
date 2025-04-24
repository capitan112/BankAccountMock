// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}

public protocol NetworkServiceProtocol {
    func fetch<T: Decodable>(_ resource: NetworkResource<T>) async throws -> T
}

public final class NetworkService: NetworkServiceProtocol {
    private let session: URLSessionProtocol

    public init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }

    private func createURLRequest<T: Decodable>(_ resource: NetworkResource<T>) -> URLRequest {
        var request = URLRequest(url: resource.url)
        request.httpMethod = resource.method.rawValue
        request.allHTTPHeaderFields = resource.headers
        request.httpBody = resource.body
        return request
    }

    public func fetch<T: Decodable>(_ resource: NetworkResource<T>) async throws -> T {
        let request = createURLRequest(resource)

        do {
            let (data, response) = try await session.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }

            guard (200 ... 299).contains(httpResponse.statusCode) else {
                throw NetworkError.responseError(httpResponse.statusCode)
            }

            if data.isEmpty && T.self != EmptyResponse.self {
                throw NetworkError.emptyResponse
            } else if T.self == EmptyResponse.self {
                return EmptyResponse() as! T
            }

            let decoder = JSONDecoder()
            do {
                return try decoder.decode(T.self, from: data)
            } catch let decodingError {
                throw NetworkError.decodingFailed(decodingError)
            }

        } catch {
            throw NetworkError.dataLoadingFailed(error)
        }
    }
}
