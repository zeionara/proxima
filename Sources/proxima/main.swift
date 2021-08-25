import nest
import Foundation

func runLongRunningTask(_ delay: UInt32, _ label: String) async -> String {
    sleep(delay)
    return label
}

print("Before semaphore")
let group = DispatchGroup()
// let semaphore = DispatchSemaphore(value: 2)
print("After semaphore")

group.enter(2)
// group.enter()

Task {
    print("Started task 1")
    let result = await runLongRunningTask(2, "test1")
    print(result)
    group.leave()
}

Task {
    print("Started task 2")
    let result = await runLongRunningTask(3, "test2")
    print(result)
    group.leave()
}

// sleep(1)
group.wait()


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
