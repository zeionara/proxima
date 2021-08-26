import nest
import Foundation


// for x in stride(from: 0.0, through: wellModel.a, by: 0.01) {
//     print("Ψ(\(x)) = \(waveFunction(x))")
// }



let group = DispatchGroup()

group.enter(1)


Task {
    for n in 1..<1000 {
        let wellModel = OneDimensionalPotentialWellAnalyticModel(length: 5)

        let firstWaveFunction = wellModel.getWaveFunction(n: n)
        let secondWaveFunction = wellModel.getWaveFunction(n: (n + 2) % 3)
        let thirdWaveFunction = wellModel.getWaveFunction(n: (n + 4) % 5)

        func waveFunction(_ x: Double) -> Double {
            return 0.2 * firstWaveFunction(x) + 0.3 * secondWaveFunction(x) + 0.5 * thirdWaveFunction(x)
        }
        
        let expectationValue = await integrate({ (x: Double) -> Double in
                let wavefunctionValue = waveFunction(x)
                return x * (wavefunctionValue ** 2.0)
            },
            from: 0,
            to: wellModel.a,
            precision: 1000,
            kind: .right,
            nParts: 2
        )
        
        // print("When n = \(n) the expectation value of the electron's coordinate is \(String(format: "%.3f", expectationValue))")
        print("\(n)\t\(expectationValue)")
    }
    
    // print()
    // print("Compute sphere volume using cartesian system without concurrency:")
    // print()

    // _ = await testPerformanceAndPrecision(
    //     min: 1000, max: 10000, step: 1000, label: "sphere volume computation", ref: 4.0 / 3.0 * Double.pi * 8.0
    // ) { precision in
    //     computeSphereVolumeUsingCartesianSystem(2.0, precision: precision, kind: .right)
    // }

    // for nParts in 2..<3 {
    //     print()
    //     print("Compute sphere volume using cartesian system with concurrency (nParts = \(nParts)):")
    //     print()

    //     _ = await testPerformanceAndPrecision(
    //         min: 1000, max: 10000, step: 1000, label: "sphere volume computation", ref: 4.0 / 3.0 * Double.pi * 8.0
    //     ) { precision in
    //         await computeSphereVolumeUsingCartesianSystemWithConcurrency(2.0, precision: precision, kind: .right, nParts: nParts)
    //     }
    // }
    
    group.leave()
}

group.wait()
