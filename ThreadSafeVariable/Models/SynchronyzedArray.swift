//
//  SynchronyzedArray.swift
//  ThreadSafeVariable
//
//  Created by Roman Movchan on 7/1/19.
//  Copyright © 2019 Roman Movchan. All rights reserved.
//

import Foundation

class SynchronizedArray<Element> {

    private let synchronizedQueue = DispatchQueue(label: "SynchronizedArray", attributes: .concurrent)
    private var array = [Element]()

}

extension SynchronizedArray {

    var first: Element? {
        var result: Element?
        synchronizedQueue.sync { result = self.array.first }
        return result
    }

    var last: Element? {
        var result: Element?
        synchronizedQueue.sync {
            result = self.array.last
        }
        return result
    }

    var count: Int {
        var result = 0
        synchronizedQueue.sync {
            result = self.array.count
        }
        return result
    }

    var isEmpty: Bool {
        var result = false
        synchronizedQueue.sync { result = self.array.isEmpty }
        return result
    }

}

extension SynchronizedArray {

    func append( _ element: Element) {
        synchronizedQueue.async(flags: .barrier) {
            self.array.append(element)
        }
    }

    func append( _ elements: [Element]) {
        synchronizedQueue.async(flags: .barrier) {
            self.array += elements
        }
    }

    func insert( _ element: Element, at index: Int) {
        synchronizedQueue.async(flags: .barrier) {
            self.array.insert(element, at: index)
        }
    }

    func remove(at index: Int, completion: ((Element) -> Void)? = nil) {
        synchronizedQueue.async(flags: .barrier) {
            let element = self.array.remove(at: index)

            DispatchQueue.main.async {
                completion?(element)
            }
        }
    }

    func removeAll(completion: (([Element]) -> Void)? = nil) {
        synchronizedQueue.async(flags: .barrier) {
            let elements = self.array
            self.array.removeAll()

            DispatchQueue.main.async {
                completion?(elements)
            }
        }
    }

}


extension SynchronizedArray: CustomStringConvertible {

    var description: String {
        var result = ""
        synchronizedQueue.sync { result = self.array.description }
        return result
    }

}
