import nest
import Foundation
import ArgumentParser
import Logging

struct Proxima: ParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "A tool for approximate quantum systems analysis",
        version: "0.0.7",
        subcommands: [Sample.self, Eigensolve.self, Gravitate.self],
        defaultSubcommand: Sample.self
    )
}

Proxima.main()

// BlockingTask {
//     measureExecutionTime("samples generation for 2d model of electrons in a potential well", accuracy: 5) {
//         // print(
//         //     await OneDimensionalPotentialWellAnalyticModel(length: 5).getSamples(100, nParts: 3)
//         // )
// 
//         let wellModel = TwoDimensionalPotentialWellAnalyticModel(length: 2, width: 5)
//         let wavefunction = wellModel.getWaveFunction(n1: 1, n2: 1)
//         func getProbability(_ args: [Double]) -> Double {
//             return wavefunction(args.first!, args.last!) ** 2
//         }
// 
//         func normalizeProbability(_ probability: Double, _ normalizationCoefficient: Double) -> Double {
//             return probability / normalizationCoefficient
//         }
// 
//         // let randomizationResult = await randomize(
//         //     getProbability,
//         //     from: [0.0, 0.0],
//         //     to: [2.0, 5.0],
//         //     precision: 100,
//         //     kind: .right,
//         //     generatorKind: .ceil
//         // )
// 
//         // let generator = Pcg64Random(seed: 16)
//         // print(randomizationResult)
//         let samples = await wellModel.getSamples(10, nParts: 10, precision: 100, seed: 17).map{
//             TwoDimensionalElectronPosition(x: $0.first!, y: $0.last!)
//         }.sorted{ $0.x > $1.x }
// 
//         print(DataBundle(samples).asTsv) // .toTsv("assets/corpora/2d-electron-positions/data.tsv")
//         
//         // print("x\ty")
//         // for sample in samples {
//             // print("\(String(format: "%.5f", sample.first!))\t\(String(format: "%.5f", sample.last!))")
//         // }
// 
//         // print(getProbability([1.0, 2.5]))
//         return nil
//     }
// }
// 
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
