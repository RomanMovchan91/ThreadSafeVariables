//
//  SynchronyzedVariableSemaphore.swift
//  ThreadSafeVariable
//
//  Created by Roman Movchan on 7/1/19.
//  Copyright © 2019 Roman Movchan. All rights reserved.
//

import Foundation

class SynchronyzedVariableSemaphore<T>: VariableWrapper<T> {

    let semaphore = DispatchSemaphore(value: 1)

    override func read() -> T {
        var value: T!
        semaphore.wait()
        value = variable
        semaphore.signal()
        return value
    }

    override func write(value: T) {
        semaphore.wait()
        variable = value
        semaphore.signal()
    }

    override func writeAndGetOld(value: T) -> T {
        let oldValue = read()
        write(value: value)
        return oldValue
    }

}

extension SynchronyzedVariableSemaphore: CustomStringConvertible where T: CustomStringConvertible {

    var description: String {
        var result = ""
        semaphore.wait()
        result = variable.description
        semaphore.signal()
        return result
    }

}

