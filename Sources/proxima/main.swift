import nest
import Foundation

let group = DispatchGroup()

group.enter(1)

// public typealias Interval = (from: Double, to: Double)

// public func splitInterval(from firstValue: Double, to lastValue: Double, nParts: Int) -> Array<Interval> {
//     let step = (lastValue - firstValue) / Double(nParts)
//     var results = [Interval]()
//     var currentValue = firstValue

//     for _ in 0..<nParts {
//         let nextValue = currentValue + step
//         results.append(Interval(from: currentValue, to: nextValue))
//         currentValue = nextValue
//     }

//     return results
// } 


Task {
    print()
    print("Compute sphere volume using cartesian system without concurrency:")
    print()

    await testPerformanceAndPrecision(
        min: 1000, max: 2000, step: 1000, label: "sphere volume computation", ref: 4.0 / 3.0 * Double.pi * 8.0
    ) { precision in
        computeSphereVolumeUsingCartesianSystem(2.0, precision: precision, kind: .right)
    }

    for nParts in 2..<3 {
        print()
        print("Compute sphere volume using cartesian system with concurrency (nParts = \(nParts)):")
        print()

        await testPerformanceAndPrecision(
            min: 1000, max: 2000, step: 1000, label: "sphere volume computation", ref: 4.0 / 3.0 * Double.pi * 8.0
        ) { precision in
            await computeSphereVolumeUsingCartesianSystemWithConcurrency(2.0, precision: precision, kind: .right, nParts: nParts)
        }
    }
    
    group.leave()
}

group.wait()
