import nest
import Foundation

// public func constantFive(_ x: Double) -> Double {
//     return Double(5.0)
// }

// public func inverse(_ x: Double) -> Double {
//     return 1.0 / x
// }

// let firstValue = 1.0
// let lastValue = 3.0

// let result = integrate(constantFive, from: firstValue, to: lastValue)

// print("The integral of the constant function y = 5 from \(String(format: "%.3f", firstValue)) to \(String(format: "%.3f", lastValue)) is equal to \(String(format: "%.3f", result))!")

// let referenceInverseFunctionResult = 1.09861228866811

// for precision in stride(from: 1, to: 1001, by: 100) {
//     let inverseFunctionResult = integrate(inverse, from: firstValue, to: lastValue, precision: precision)
//     print(
//         "The integral of the inverse function y = 1 / x from \(String(format: "%.3f", firstValue)) to \(String(format: "%.3f", lastValue))" + 
//         " is equal to \(String(format: "%.5f", inverseFunctionResult))! (number of intervals = \(precision), absolute error=" +
//         "\(String(format: "%.5f", abs(referenceInverseFunctionResult - inverseFunctionResult) / referenceInverseFunctionResult)))"
//     )
// }

// public func add(_ lhs: Double, _ rhs: Double) -> Double {
//     return lhs + rhs
// }

// public func computeElementarySquare(_ leftHeight: Double, _ rightHeight: Double) -> Double {
//     let step = 0.2
//     let lhCopy = 2.2
//     let kind: Int = 2
//     print(lhCopy + 0.2)
//     if kind == 0 {
//         return rightHeight * step
//     } else if kind == 1 {
//         return leftHeight * step
//     } else {
//         print("left height = \(leftHeight), right height = \(rightHeight)")
//         return leftHeight + rightHeight
//         // return add(leftHeight as! Double, rightHeight as! Double)
//     }
// }

// public func integrated(
//     _ getValue: (Double) -> Double,
//     from firstValue: Double, to lastValue: Double, precision nIntervals: Int = 10, kind: IntegralKind = .right
// ) -> Double {
//     let step = abs(lastValue - firstValue) / Double(nIntervals)
//     // print(step)
//     return integrate(
//         getValue, from: firstValue, to: lastValue, step: step, zero: 0.0, computeSquare: computeElementarySquare
//     )
// }



// print(computeCircleSquare(2.0, precision: 100, kind: .left))
// print(computeCircleSquare(2.0, precision: 100, kind: .mean))
// print(computeCircleSquare(2.0, precision: 100, kind: .right))
// print(computeElementarySquare(0.2, 0.3))





// print(computeSphereVolume(2.0, kind: .left))
// print(computeSphereVolume(2.0, kind: .mean))
// print(computeSphereVolume(2.0, kind: .right))

print(
    traceExecutionTime("sphere volume computation (z-axis + polar coordinates)") {
        computeSphereVolume(2.0, precision: 1000, kind: .right)
    }
)

print(
    traceExecutionTime("sphere volume computation (cartesian)") {
        computeSphereVolumeUsingCartesianSystem(2.0, precision: 1000, kind: .right)
    }
)
