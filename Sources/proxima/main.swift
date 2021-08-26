import nest
import Foundation

let wellModel = OneDimensionalPotentialWellAnalyticModel(length: 5)

// for n in 1..<10 {
//     print("When n = \(n) electron has energy \(wellModel.getEnergy(n: n))")
// }

let waveFunction = wellModel.getWaveFunction(n: 1)

for x in stride(from: 0.0, through: wellModel.a, by: 0.01) {
    print("Ψ(\(x)) = \(waveFunction(x))")
}



// let group = DispatchGroup()

// group.enter(1)


// Task {
//     print()
//     print("Compute sphere volume using cartesian system without concurrency:")
//     print()

//     _ = await testPerformanceAndPrecision(
//         min: 1000, max: 10000, step: 1000, label: "sphere volume computation", ref: 4.0 / 3.0 * Double.pi * 8.0
//     ) { precision in
//         computeSphereVolumeUsingCartesianSystem(2.0, precision: precision, kind: .right)
//     }

//     for nParts in 2..<3 {
//         print()
//         print("Compute sphere volume using cartesian system with concurrency (nParts = \(nParts)):")
//         print()

//         _ = await testPerformanceAndPrecision(
//             min: 1000, max: 10000, step: 1000, label: "sphere volume computation", ref: 4.0 / 3.0 * Double.pi * 8.0
//         ) { precision in
//             await computeSphereVolumeUsingCartesianSystemWithConcurrency(2.0, precision: precision, kind: .right, nParts: nParts)
//         }
//     }
    
//     group.leave()
// }

// group.wait()
