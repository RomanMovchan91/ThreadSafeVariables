//
//  ViewController.swift
//  ThreadSafeVariable
//
//  Created by Roman Movchan on 6/27/19.
//  Copyright © 2019 Roman Movchan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private let queue = DispatchQueue(label: "TestingQueue", attributes: .concurrent)

    private var isExecuting = false {
        didSet {
            testType.isEnabled = !self.isExecuting
            startButton.isEnabled = !self.isExecuting
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var testType: UISegmentedControl!
    @IBOutlet weak var startButton: UIButton!
    
    @IBAction func start(_ sender: Any) {
        switch testType.selectedSegmentIndex {
        case 0:
            checkVariable(variable: SynchronyzedVariableBarrier<Int>(0))
        case 1:
            checkVariable(variable: SynchronyzedVariableSemaphore<Int>(0))
        case 2:
            checkVariable(variable: SynchronyzedVariableLock<Int>(0))
        case 3:
            checkArray()
        default:
            fatalError("Wrong index")
        }
    }
    
}

private extension ViewController {

    func checkVariable<VariableWrapper: SynchronyzedVariable>(variable: VariableWrapper)
        where VariableWrapper.Variable == Int {
        isExecuting = true
        queue.async {
            DispatchQueue.concurrentPerform(iterations: 1000) { index in
                let oldValue = variable.writeAndGetOld(value: index)
                print("\(oldValue) => \(index):\(variable.read())")
            }
        }
        queue.async(flags: .barrier) {
            print("done, value: \(variable.read())")
            variable.write(value: 0)
            DispatchQueue.main.async {
                self.isExecuting = false
            }

        }
    }

    func checkArray() {
        isExecuting = true
        let array = SynchronizedArray<Int>()
        DispatchQueue.concurrentPerform(iterations: 1000) { index in
            let last = array.last ?? 0
            array.append(last + 1)
        }
        queue.sync(flags: .barrier) {
            print("done, array.count: \(array.count)")
            DispatchQueue.main.async {
                self.isExecuting = false
            }
        }
    }

}

