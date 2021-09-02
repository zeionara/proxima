import Foundation
import nest

public typealias OneDimensionalSpacialWavefunction = (_ x: Double) -> Double

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

    public func sample(_ nSamples: Int, n: Int = 1, from: Double = 0.0, to: Double? = .none, precision: Int = 10000) -> [Double] {
        let wavefunction = getWaveFunction(n: n)

        return (0..<nSamples).map{x in
            return Double.random(
                { (x: Double) -> Double in
                    wavefunction(x) ** 2
                },
                from: from,
                to: to ?? a,
                precision: precision
            )
        }
    }

    public func sample(_ nSamples: Int, nParts: Int, n: Int = 1, from: Double = 0.0, to: Double? = .none, precision: Int = 10000) async -> [Double] {
        assert(nParts > 1)
        
        var inputs = [Int]()
        let nSamplesPerPart = nSamples / nParts
        for i in 0..<nParts - 1 {
            inputs.append(nSamplesPerPart)
        }
        inputs.append(nSamplesPerPart + (nSamples - nSamplesPerPart * nParts))

        
        // let samples = []
        // for sampleSet in await concurrrentMap(
        //     inputs
        // ) { (nSamples: Int) in
        //     sample(
        //         nSamples, n: n, from: from, to: to, precision: precision
        //     )
        // } {
        //     for sample in sampleSet {
        //         samples.append(sample)
        //     }
        // }

        return Array.chain(
            await concurrentMap(
                inputs
            ) { (nSamples: Int) in
                sample(
                    nSamples, n: n, from: from, to: to, precision: precision
                )
            }
        )
    }
}
