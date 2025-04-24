//
//  SeededRandomNumberGenerator.swift
//  BankAccountMock
//
//  Created by Oleksiy Chebotarov on 23/04/2025.
//

import Foundation

struct SeededRandomNumberGenerator: RandomNumberGenerator {
    init(seed: UInt64) {
        self.seed = seed
    }

    private var seed: UInt64

    mutating func next() -> UInt64 {
        seed = 2_862_933_555_777_941_757 &* seed &+ 3_037_000_313_415_575_223
        return seed
    }
}
