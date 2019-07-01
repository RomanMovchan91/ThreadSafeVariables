//
//  VariableWrapper.swift
//  ThreadSafeVariable
//
//  Created by Roman Movchan on 7/1/19.
//  Copyright © 2019 Roman Movchan. All rights reserved.
//

import Foundation

class VariableWrapper<T>: VariableWrapperProtocol {

    typealias Variable = T

    var variable: T

    required init(_ value: T) {
        variable = value
    }

    func read() -> T {
        return variable
    }

    func write(value: T) {
        variable = value
    }

    func writeAndGetOld(value: T) -> T {
        let oldValue = variable
        variable = value
        return oldValue
    }
}

