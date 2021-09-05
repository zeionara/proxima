import nest
import Foundation

// print(
//     OneDimensionalPotentialWellAnalyticModel(length: 5).sample(10)
// )

BlockingTask {
    measureExecutionTime("samples generation for 2d model of electrons in a potential well", accuracy: 5) {
        // print(
        //     await OneDimensionalPotentialWellAnalyticModel(length: 5).getSamples(100, nParts: 3)
        // )

        let wellModel = TwoDimensionalPotentialWellAnalyticModel(length: 2, width: 5)
        let wavefunction = wellModel.getWaveFunction(n1: 1, n2: 1)
        func getProbability(_ args: [Double]) -> Double {
            return wavefunction(args.first!, args.last!) ** 2
        }

        func normalizeProbability(_ probability: Double, _ normalizationCoefficient: Double) -> Double {
            return probability / normalizationCoefficient
        }

        // let randomizationResult = await randomize(
        //     getProbability,
        //     from: [0.0, 0.0],
        //     to: [2.0, 5.0],
        //     precision: 100,
        //     kind: .right,
        //     generatorKind: .ceil
        // )

        // print(randomizationResult)
        let samples = await wellModel.getSamples(1000, nParts: 10, precision: 1000)
        
        print("x\ty")
        for sample in samples {
            print("\(String(format: "%.5f", sample.first!))\t\(String(format: "%.5f", sample.last!))")
        }

        // print(getProbability([1.0, 2.5]))
        return nil
    }
}

// measureExecutionTime("sphere volume computation using hardcoded implementation") {
//     print(
//         computeSphereVolumeUsingCartesianSystem(
//             5,
//             precision: 2000
//         )
//     )
// }


// BlockingTask {
// measureExecutionTime("sphere volume computation explicit multivariable integration", accuracy: 5) {
//         let referenceValue = 4.0 / 3.0 * Double.pi * (5.0 ** 3)
//         let value = await computeSphereVolumeViaExplicitMultivariateIntegration(
//             5,
//             precision: 5000
//         )
//         return "; absolute error = \(String(format: "%.5f", abs(value - referenceValue) / referenceValue))"
// }
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
