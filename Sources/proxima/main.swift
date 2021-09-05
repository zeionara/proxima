import nest
import Foundation

// print(
//     OneDimensionalPotentialWellAnalyticModel(length: 5).sample(10)
// )

// BlockingTask {
//     print(
//         await OneDimensionalPotentialWellAnalyticModel(length: 5).sample(10, nParts: 3)
//     )
// }

// measureExecutionTime("sphere volume computation using hardcoded implementation") {
//     print(
//         computeSphereVolumeUsingCartesianSystem(
//             5,
//             precision: 2000
//         )
//     )
// }


// BlockingTask {
measureExecutionTime("sphere volume computation explicit multivariable integration", accuracy: 5) {
        let referenceValue = 4.0 / 3.0 * Double.pi * (5.0 ** 3)
        let value = await computeSphereVolumeViaExplicitMultivariateIntegration(
            5,
            precision: 1000
        )
        return "; absolute error = \(String(format: "%.5f", abs(value - referenceValue) / referenceValue))"
}
// }

// let wellModel = TwoDimensionalPotentialWellAnalyticModel(length: 5, width: 10)
// let wavefunction = wellModel.getWaveFunction(n1: 1, n2: 2)

// public func density(_ x: [Double]) -> Double {
//     wavefunction(x.first!, x.last!) ** 2.0
// }

// measureExecutionTime("2d potential well wavefunction integration") {
//     BlockingTask {
//         print(
//             await integrate(
//                 density,
//                 from: [0.0, 0.0],
//                 to: [wellModel.a1, wellModel.a2],
//                 precision: 2000,
//                 nParts: 12
//             )
//         )
//     }
// }
