import Foundation

public func traceExecutionTime<Type>(_ label: String, _ function: () -> Type) -> Type {
    let start = DispatchTime.now()
    let result = function()
    let end = DispatchTime.now()
    let nSeconds = Double(end.uptimeNanoseconds - start.uptimeNanoseconds) / 1_000_000_000
    print("\(label) has completed in \(String(format: "%.3f", nSeconds)) seconds")
    return result
}
