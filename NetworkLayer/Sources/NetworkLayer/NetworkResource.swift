//
//  NetworkResource.swift
//  NetworkLayer
//
//  Created by Oleksiy Chebotarov on 13/04/2025.
//

import Foundation

public struct NetworkResource<T: Decodable> {
    let url: URL
    let method: HTTPMethod
    let headers: [String: String]
    let body: Data?

    public init(
        url: URL,
        method: HTTPMethod = .get,
        headers: [String: String] = ["Content-Type": "application/json"],
        body: Data? = nil
    ) {
        self.url = url
        self.method = method
        self.headers = headers
        self.body = body
    }
}
