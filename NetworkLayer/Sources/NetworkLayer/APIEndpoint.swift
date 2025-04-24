//
//  APIEndpoint.swift
//  NetworkLayer
//
//  Created by Oleksiy Chebotarov on 13/04/2025.
//

import Foundation

public enum APIEndpoint {
    case accounts, accountDetails(id: Int)

    private var baseURL: URL {
        let urlSting = "https://gist.githubusercontent.com/capitan112"
        return URL(string: urlSting)!
    }

    public var url: URL {
        switch self {
        case .accounts:
            return baseURL.appendingPathComponent("/1e2c5c6491a0a0e358c51748a10c8507/raw/82500409cbda4050b9b1e2b2edc727e93fdfc4ec/accounts")
        case let .accountDetails(id: id):
            return baseURL.appendingPathComponent("/04a702428612ff7144549eb514beb0dd/raw/b59fdba10d92de70cb237c74134eb262eefa3b99/accountDetails")
        }
    }
}
