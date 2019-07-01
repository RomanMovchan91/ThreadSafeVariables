//
//  SynchronyzedVariableLock.swift
//  ThreadSafeVariable
//
//  Created by Roman Movchan on 7/1/19.
//  Copyright © 2019 Roman Movchan. All rights reserved.
//

import Foundation

class SynchronyzedVariableLock<T>: VariableWrapper<T> {

    private var locker = NSLock()

    override func read() -> T {
        var value: T!
        locker.lock()
        value = variable
        locker.unlock()
        return value
    }

    override func write(value: T) {
        locker.lock()
        variable = value
        locker.unlock()
    }

    override func writeAndGetOld(value: T) -> T {
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
