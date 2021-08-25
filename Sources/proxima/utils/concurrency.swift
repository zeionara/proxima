import Foundation

extension DispatchGroup {
    public func enter(_ nWorkers: Int) {
        for i in 0..<nWorkers {
            self.enter()
        }
    }
}

// func runLongRunningTask(_ delay: UInt32, _ label: String) async -> String {
//     sleep(delay)
//     return label
// }

actor SynchronisedCollection<Item> {
    var items = [Item]()
    
    func append(_ item: Item) {
        items.append(item)
    }
}

actor OptionalSemaphore {
    // public var semaphore: DispatchSemaphore?
    // public let nWorkers: Int?
    public var nFreeWorkers: Int

    public init(_ nWorkers: Int? = .none) {
        // if let nWorkers_ = nWorkers {
        //     self.nWorkers = nWorkers_
        //     self.semaphore = DispatchSemaphore(value: nWorkers_)
        // } else {
        //     self.nWorkers = .none
        //     self.semaphore = .none
        // }
        nFreeWorkers = nWorkers ?? -1
    }
    
    func wait() {
        while self.nFreeWorkers < 1 {
            sleep(1)
        }
        nFreeWorkers -= 1
        // if let semaphore_ = semaphore {
        //     print("waiting for semaphore")
        //     semaphore_.wait()
        //     print("got semaphore")
        // }
    }

    func signall() {
        nFreeWorkers += 1
        // print("attempting to release")
        // if let semaphore_ = semaphore {
        //     print("releasing semaphore")
        //     semaphore_.signal()
        //     print("released semaphore")
        // }
    }
}

public func concurrentMap<InputType, OutputType>(_ inputs: Array<InputType>, handler: @escaping (InputType) -> OutputType) async -> Array<OutputType> { // nWorkers: Int? = .none
    let externallyAvailableResults = SynchronisedCollection<OutputType>()
    // let semaphore = OptionalSemaphore(nWorkers) // Doesn't work
    // var semaphore: DispatchSemaphore? = .none
    // if let nWorkers_ = nWorkers {
    //     semaphore = DispatchSemaphore(value: nWorkers_)
    // }

    await withTaskGroup(of: OutputType.self) { taskGroup in 
        for input in inputs {
            let value = taskGroup.addTask {
                // if let semaphore_ = semaphore {
                //     semaphore_.wait()
                // }
                // await semaphore.wait()
                let result = handler(input)
                // print("before attempting to release")
                // await semaphore.signall()
                // if let semaphore_ = await semaphore.semaphore {
                //     print("ok")
                // }
                // print("after attempting to release")
                return result
            }
        }

        for await result in taskGroup {
            await externallyAvailableResults.append(result)
        }
    }

    return await externallyAvailableResults.items // [OutputType]() // externallyAvailableResults

    // let group = DispatchGroup()

    // group.enter(inputs.count)

    // for input in inputs {
    //     Task {
    //         print("Started handling \(input)")
    //         let result = await runLongRunningTask(2, "test1")
            
    //         lock.lock()
    //         results.append(handler(input))
    //         lock.unlock()

    //         group.leave()
    //     }


    //     // results.append(handler(input))
    // }
    
    // return results
}
