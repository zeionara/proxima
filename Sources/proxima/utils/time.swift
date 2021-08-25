import Foundation

public func traceExecutionTime<Type>(_ label: String, _ function: () -> Type, generateResultDependentSuffix: Optional<(Type) -> String> = .none) -> Type {
    let start = DispatchTime.now()
    let result = function()
    let end = DispatchTime.now()
    let nSeconds = Double(end.uptimeNanoseconds - start.uptimeNanoseconds) / 1_000_000_000

    var suffix = ""
    if let generateResultDependentSuffix_ = generateResultDependentSuffix {
        suffix = "; \(generateResultDependentSuffix_(result))"
    }

    print("\(label) has completed in \(String(format: "%.3f", nSeconds)) seconds\(suffix)")
    return result
}

public func traceExecutionTimeAndAbsoluteError(_ label: String, ref referenceValue: Double, _ function: () -> Double) -> Double {
    return traceExecutionTime(label, function) { integrationResult in
        "absolute error: \(String(format: "%.5f", abs(integrationResult - referenceValue) / referenceValue))"
    }
}

public func testPerformanceAndPrecision(min minPrecision: Int, max maxPrecision: Int, step: Int, label: String, ref referenceValue: Double, function: (Int) -> Double) {
    for precision in stride(from: minPrecision, to: maxPrecision + 1, by: step) {
        print("precision = \(precision)")
        traceExecutionTimeAndAbsoluteError(label, ref: referenceValue) {
            function(precision)
        }
    }
}
