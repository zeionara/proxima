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

public func concurrentMap<InputType, OutputType>(_ inputs: Array<InputType>, handler: @escaping (InputType) -> OutputType) async -> Array<OutputType> {
    let externallyAvailableResults = SynchronisedCollection<OutputType>() // [OutputType]()
    // let lock = NSLock()
    // let dispatchGroup = DispatchGroup()

    // dispatchGroup.enter(inputs.count)

    // Task {
        // for item in inputs {
        //     await externallyAvailableResults.append(handler(item))
        //     dispatchGroup.leave()
        // }
    await withTaskGroup(of: OutputType.self) { taskGroup in 
        for input in inputs {
            let value = taskGroup.addTask {
                // let result = handler(input)
                // dispatchGroup.leave()
                return handler(input)
            }
        }

        // var results = [OutputType]()

        for await result in taskGroup {
            // results.append(result)
            await externallyAvailableResults.append(result)
        }

        // externallyAvailableResults = results
        // for element in results {
        //     await externallyAvailableResults.append(element)
        // }
    }
    // }


    // dispatchGroup.wait()

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
