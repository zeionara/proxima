import nest

public func computeConstantFunctionIntegral(constant: Double, from firstValue: Double, to lastValue: Double, precision: Int = 10000, kind: IntegralKind = .right) async -> Double {
    func constantFunction(_ x: Double) -> Double {
        return constant
    }

    return await integrate(constantFunction, from: firstValue, to: lastValue, precision: precision, kind: kind)
}
