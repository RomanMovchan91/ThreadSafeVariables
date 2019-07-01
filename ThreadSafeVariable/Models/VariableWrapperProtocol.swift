//
//  VariableWrapperProtocol.swift
//  ThreadSafeVariable
//
//  Created by Roman Movchan on 7/1/19.
//  Copyright © 2019 Roman Movchan. All rights reserved.
//

import Foundation

protocol VariableWrapperProtocol: class {

    associatedtype Variable

    init(_ value: Variable)

    func read() -> Variable

    func write(value: Variable)

    func writeAndGetOld(value: Variable) -> Variable

}
