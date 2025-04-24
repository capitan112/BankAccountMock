//
//  NetworkError.swift
//  NetworkLayer
//
//  Created by Oleksiy Chebotarov on 13/04/2025.
//

import Foundation

public enum NetworkError: Error, Equatable {
    case invalidURL(Error)
    case dataLoadingFailed(Error)
    case decodingFailed(Error)
    case emptyResponse
    case invalidResponse
    case responseError(Int)

    public static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case let (.invalidURL(lError), .invalidURL(rError)),
             let (.dataLoadingFailed(lError), .dataLoadingFailed(rError)),
             let (.decodingFailed(lError), .decodingFailed(rError)):
            return type(of: lError) == type(of: rError)
        case (.emptyResponse, .emptyResponse):
            return true
        case let (.responseError(lCode), .responseError(rCode)):
            return lCode == rCode
        default:
            return false
        }
    }
}
