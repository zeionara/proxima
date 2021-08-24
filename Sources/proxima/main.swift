import nest
import Foundation

// public protocol Addable {
//     static func +(_ lhs: Self, _ rhs: Self) -> Self
// }

// extension Double: Addable {
//     static public func +(_ lhs: Double, _ rhs: Double) -> Double {
//         return lhs + rhs
//     }
// }

// public func integrate<InputType: Numeric, OutputType: Numeric>(_ getValue: (InputType) -> OutputType, from firstValue: InputType, to lastValue: InputType) -> OutputType {
//     return getValue(firstValue) + getValue(lastValue)
// }

public func constantFive(_ x: Double) -> Double {
    return Double(5.0)
}

public func inverse(_ x: Double) -> Double {
    return 1.0 / x
}

let firstValue = 1.0
let lastValue = 3.0

let result = integrate(constantFive, from: firstValue, to: lastValue)

print("The integral of the constant function y = 5 from \(String(format: "%.3f", firstValue)) to \(String(format: "%.3f", lastValue)) is equal to \(String(format: "%.3f", result))!")

let referenceInverseFunctionResult = 1.09861228866811

for precision in stride(from: 1, to: 1001, by: 100) {
    let inverseFunctionResult = integrate(inverse, from: firstValue, to: lastValue, precision: precision)
    print(
        "The integral of the inverse function y = 1 / x from \(String(format: "%.3f", firstValue)) to \(String(format: "%.3f", lastValue))" + 
        " is equal to \(String(format: "%.5f", inverseFunctionResult))! (number of intervals = \(precision), absolute error=" +
        "\(String(format: "%.5f", abs(referenceInverseFunctionResult - inverseFunctionResult) / referenceInverseFunctionResult)))"
    )
}
