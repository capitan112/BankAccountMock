//
//  LoadingStage.swift
//  BankAccountMock
//
//  Created by Oleksiy Chebotarov on 23/04/2025.
//

import Foundation

enum LoadingStage<T> {
    case initial
    case loading
    case loaded(T)
    case error(_ errorMessage: String)
}
