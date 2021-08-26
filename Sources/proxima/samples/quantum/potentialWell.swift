import Foundation

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
}
