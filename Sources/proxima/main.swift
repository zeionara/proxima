import nest
import Foundation

let group = DispatchGroup()

group.enter(1)

public typealias Interval = (from: Double, to: Double)

public func splitInterval(from firstValue: Double, to lastValue: Double, nParts: Int) -> Array<Interval> {
    let step = (lastValue - firstValue) / Double(nParts)
    var results = [Interval]()
    var currentValue = firstValue

    for i in 0..<nParts {
        let nextValue = currentValue + step
        results.append(Interval(from: currentValue, to: nextValue))
        currentValue = nextValue
    }

    return results
} 


Task {
    print()
    print("Compute sphere volume using cartesian system without concurrency:")
    print()

    await testPerformanceAndPrecision(
        min: 1000, max: 10000, step: 1000, label: "sphere volume computation", ref: 4.0 / 3.0 * Double.pi * 8.0
    ) { precision in
        computeSphereVolumeUsingCartesianSystem(2.0, precision: precision, kind: .right)
    }

    print()
    print("Compute sphere volume using cartesian system with concurrency:")
    print()

    await testPerformanceAndPrecision(
        min: 1000, max: 10000, step: 1000, label: "sphere volume computation", ref: 4.0 / 3.0 * Double.pi * 8.0
    ) { precision in
        await computeSphereVolumeUsingCartesianSystemWithConcurrency(2.0, precision: precision, kind: .right)
    }
    
    //
    //
    //

    // let r = 2.0
    // let kind = IntegralKind.right
    // let precision = 10000
    // let nParts = 10
    
    // let results = await concurrentMap(
    //     splitInterval(from: 0.0, to: r, nParts: nParts)
    // ) { interval -> Double in
    //     // print("Handling interval \(interval)...")
    //     let result = 4.0 * integrate( { (x: Double) -> Double in
    //             return computeElementarySphereSquare(
    //                 r,
    //                 x: x,
    //                 precision: precision,
    //                 kind: kind
    //             )
    //         },
    //         from: interval.from,
    //         to: interval.to,
    //         precision: precision / nParts,
    //         kind: kind
    //     )
    //     // print("Handled interval \(interval)")
    //     return result
    // }

    // print(results.reduce(0, +))
    
    // let concurrentVolume = await computeSphereVolumeUsingCartesianSystemWithConcurrency(2.0, precision: 10000)

    // print(concurrentVolume)

    // let volume = computeSphereVolumeUsingCartesianSystem(2.0, precision: 10000)

    // print(volume)
    // print(volume)

    //
    //
    //

    // let results = await concurrentMap(
    //     ["foo", "bar", "baz", "qux", "quux", "quuz"]
    //     // nWorkers: 2
    // ) { input -> String in
    //     print("Handling \(input)...")
    //     sleep(2)
    //     print("Handled \(input)")
    //     return "Handled \(input)"
    // }
    // print(results)
    group.leave()
}

group.wait()

//
//
//

// func runLongRunningTask(_ delay: UInt32, _ label: String) async -> String {
//     sleep(delay)
//     return label
// }

// func simpleHandler(_ input: String) -> String {
//     return "Handled \(input)"
// }

// print(results)
// 
// print("Before semaphore")
// let group = DispatchGroup()
// // let semaphore = DispatchSemaphore(value: 2)
// print("After semaphore")

// group.enter(2)
// group.enter()

// TaskGroup().async() {
//     print("ok")
// }

// var ok = [String]()

// Task {
//     await withTaskGroup(of: String.self) { tgroup in 
//         for input in ["foo", "bar"] {
//             let value = tgroup.addTask {
//                 sleep(1)
//                 print(input)
//                 group.leave()
//                 return "handled \(input)"
//                 // do work and return something
//             }
//             print(value)
//         }

//         var results = [String]()

//         for await result in tgroup {
//             results.append(result)
//         }

//         print(results)

//         ok = results
//     }
// }



// Task {
//     print("Started task 1")
//     let result = await runLongRunningTask(2, "test1")
//     print(result)
//     group.leave()
// }

// Task {
//     print("Started task 2")
//     let result = await runLongRunningTask(3, "test2")
//     print(result)
//     group.leave()
// }

// sleep(1)
// group.wait()
// sleep(1)
// print(ok)

// print("Compute sphere volume using z-axis + polar coordinates:")
// print()

// testPerformanceAndPrecision(
//     min: 100, max: 1000, step: 100, label: "sphere volume computation", ref: 4.0 / 3.0 * Double.pi * 8.0
// ) { precision in
//     computeSphereVolume(2.0, precision: precision, kind: .right)
// }

// print()
// print("Compute sphere volume using cartesian system:")
// print()

// testPerformanceAndPrecision(
//     min: 100, max: 1000, step: 100, label: "sphere volume computation", ref: 4.0 / 3.0 * Double.pi * 8.0
// ) { precision in
//     computeSphereVolumeUsingCartesianSystem(2.0, precision: precision, kind: .right)
// }
