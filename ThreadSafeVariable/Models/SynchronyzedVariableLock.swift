//
//  SynchronyzedVariableLock.swift
//  ThreadSafeVariable
//
//  Created by Roman Movchan on 7/1/19.
//  Copyright © 2019 Roman Movchan. All rights reserved.
//

import Foundation

class SynchronyzedVariableLock<T>: SynchronyzedVariable {

    typealias Variable = T

    private var variable: T

    private var locker = NSLock()

    required init(_ value: T) {
        variable = value
    }

    func read() -> T {
        var value: T!
        locker.lock()
        value = variable
        locker.unlock()
        return value
    }

    func write(value: T) {
        locker.lock()
        variable = value
        locker.unlock()
    }

    func writeAndGetOld(value: T) -> T {
        let oldValue = read()
        write(value: value)
        return oldValue
    }

}

extension SynchronyzedVariableLock: CustomStringConvertible where T: CustomStringConvertible {

    var description: String {
        var result = ""
        locker.lock()
        result = variable.description
        locker.unlock()
        return result
    }

}
