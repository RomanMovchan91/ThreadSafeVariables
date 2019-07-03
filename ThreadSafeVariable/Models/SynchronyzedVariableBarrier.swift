//
//  SynchronyzedVariableBarrier.swift
//  ThreadSafeVariable
//
//  Created by Roman Movchan on 7/1/19.
//  Copyright © 2019 Roman Movchan. All rights reserved.
//

import Foundation

class SynchronyzedVariableBarrier<T>: SynchronyzedVariable {

    typealias Variable = T

    private var variable: T

    private let synchronizedQueue = DispatchQueue(label: "SynchronizedVariableBarrier", attributes: .concurrent)

    required init(_ value: T) {
        variable = value
    }

    func read() -> T {
        var value: T!
        synchronizedQueue.sync {
            value = variable
        }
        return value
    }

    func write(value: T) {
        synchronizedQueue.async(flags: .barrier) {
            self.variable = value
        }
    }

    func writeAndGetOld(value: T) -> T {
        let oldValue = read()
        write(value: value)
        return oldValue
    }

}

extension SynchronyzedVariableBarrier: CustomStringConvertible where T: CustomStringConvertible {

    var description: String {
        var result = ""
        synchronizedQueue.sync { result = self.variable.description }
        return result
    }

}
