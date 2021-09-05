import nest

public func reciprocal(_ x: Double) -> Double {
    return 1.0 / x
}

public func computeReciprocalFunctionIntegral(from firstValue: Double, to lastValue: Double, precision: Int = 10000, kind: IntegralKind = .right) async -> Double {
    return await Double.integrate(reciprocal, from: firstValue, to: lastValue, precision: precision, kind: kind)
}
