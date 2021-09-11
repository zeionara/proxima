import Foundation
import nest
import PcgRandom
import Logging

public typealias OneDimensionalSpacialWavefunction = (_ x: Double) -> Double
public typealias TwoDimensionalSpacialWavefunction = (_ x: Double, _ y: Double) -> Double

public struct OneDimensionalPotentialWellAnalyticModel {
    public let a: Double

    public init(length a: Double) {
        self.a = a
    }

    public func getEnergy(n: Int) -> Double {
        assert(n > 0) // The main quantum number must be a natural number

        return (Double.pi ** 2.0) * (Double.hBar ** 2.0) * (Double(n) ** 2.0) / (
            2.0 * (Double.mE) * (a ** 2.0)
        )
    }

    public func getWaveFunction(n: Int) -> OneDimensionalSpacialWavefunction {
        let nAsDouble = Double(n)
        
        func wavefunction(_ x: Double) -> Double {
            return (2.0 / a).squareRoot() * sin(Double.pi * nAsDouble * x / a)
        }

        return wavefunction
    }

    // public func sample(_ nSamples: Int, n: Int = 1, from: Double = 0.0, to: Double? = .none, precision: Int = 10000) -> [Double] {
    //     let wavefunction = getWaveFunction(n: n)

    //     return (0..<nSamples).map{x in
    //         return Double.random(
    //             { (x: Double) -> Double in
    //                 wavefunction(x) ** 2
    //             },
    //             from: from,
    //             to: to ?? a,
    //             precision: precision
    //         )
    //     }
    // }

    public func getSamples(
        _ nSamples: Int, nParts: Int, n: Int = 1, from: Double = 0.0, to: Double? = .none, precision: Int = 10000,
        seed: Int
    ) async -> [Double] {
        let wavefunction = getWaveFunction(n: n)

        return await sample(
            { (x: Double) -> Double in
                wavefunction(x) ** 2
            },
            nSamples,
            nParts: nParts,
            from: from,
            to: to ?? a,
            precision: precision,
            seed: seed
        )
        // assert(nParts > 1)
        
        // var inputs = [Int]()
        // let nSamplesPerPart = nSamples / nParts
        // for i in 0..<nParts - 1 {
        //     inputs.append(nSamplesPerPart)
        // }
        // inputs.append(nSamplesPerPart + (nSamples - nSamplesPerPart * nParts))

        
        // // let samples = []
        // // for sampleSet in await concurrrentMap(
        // //     inputs
        // // ) { (nSamples: Int) in
        // //     sample(
        // //         nSamples, n: n, from: from, to: to, precision: precision
        // //     )
        // // } {
        // //     for sample in sampleSet {
        // //         samples.append(sample)
        // //     }
        // // }

        // return Array.chain(
        //     await concurrentMap(
        //         inputs
        //     ) { (nSamples: Int) in
        //         sample(
        //             nSamples, n: n, from: from, to: to, precision: precision
        //         )
        //     }
        // )
    }
}

public struct TwoDimensionalPotentialWellAnalyticModel {
    public let a1: Double
    public let a2: Double

    public init(length a1: Double, width a2: Double) {
        self.a1 = a1
        self.a2 = a2
    }

    public init(size: Double) {
        self.a1 = size
        self.a2 = size
    }

    public func getEnergy(n1: Int, n2: Int) -> Double {
        assert(n1 > 0 && n2 > 0) // The main quantum number must be a natural number

        return (Double.pi ** 2.0) * (Double.hBar ** 2.0) / (
            2.0 * (Double.mE)
        ) * (
            (
                Double(n1) / a1
            ) ** 2.0 +
            (
                Double(n2) / a2
            ) ** 2.0
        )
    }

    public func getWaveFunction(n1: Int, n2: Int) -> TwoDimensionalSpacialWavefunction {
        assert(n1 > 0 && n2 > 0) // The main quantum number must be a natural number
        
        let n1AsDouble = Double(n1)
        let n2AsDouble = Double(n2)
        
        func wavefunction(_ x: Double, _ y: Double) -> Double {
            return (4.0 / (a1 * a2)).squareRoot() * sin(Double.pi * n1AsDouble * x / a1) * sin(Double.pi * n2AsDouble * y / a2)
        }

        return wavefunction
    }

    // public func sample(_ nSamples: Int, n1: Int = 1, n2: Int = 1, from: Double = 0.0, to: Double? = .none, precision: Int = 10000) -> [Double] {
    //     let wavefunction = getWaveFunction(n1: n1, n2: n2)

    //     return (0..<nSamples).map{x in
    //         return Double.random(
    //             { (x: Double) -> Double in
    //                 wavefunction(x) ** 2
    //             },
    //             from: from,
    //             to: to ?? a,
    //             precision: precision
    //         )
    //     }
    // }

    public func getSamples(_ nSamples: Int, nParts: Int, n1: Int = 1, n2: Int = 1,
        from: [Double] = [0.0, 0.0], to: [Double]? = .none, precision: Int = 10000, seed: Int
    ) async -> [[Double]] {
        let wavefunction = getWaveFunction(n1: n1, n2: n2)

        return await sample(
            { (x: [Double]) -> Double in
                wavefunction(x.first!, x.last!) ** 2
            },
            nSamples,
            nParts: nParts,
            from: from,
            to: to ?? [a1, a2],
            precision: precision,
            seed: seed,
            logger: Logger(label: "Sampler")
            // generator: generator
        )
        //  {
        //     return DefaultSeedableRandomNumberGenerator($0)
        // }
    }
}
