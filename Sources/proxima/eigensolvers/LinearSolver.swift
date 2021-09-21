import Foundation

public struct LinearEigensolver: Eigensolver {
    public typealias OperatorType = Matrix<Double>

    public func solve(_ solvedOperator: OperatorType?, nIterations: Int = 5) -> Array<EigenPair<OperatorType.OperableType>> {
        assert(nIterations > 0)
        let unwrappedOperator = solvedOperator!
        var currentEstimation = unwrappedOperator.elements.first!
        var eigenValueEstimation: Double = 1.0
        for _ in 0...nIterations {
            currentEstimation = (unwrappedOperator .* currentEstimation).normalized
            eigenValueEstimation = (unwrappedOperator .* currentEstimation).elements.first! / currentEstimation.elements.first! 
        }
        return [EigenPair(vector: currentEstimation, value: eigenValueEstimation)]
    }
}

public struct QRSolver: Eigensolver {
    public typealias OperatorType = Matrix<Double>

    public func solve(_ solvedOperator: OperatorType?, nIterations: Int = 5) -> Array<EigenPair<OperatorType.OperableType>> {
        assert(nIterations > 0)
        let unwrappedOperator = solvedOperator!
        var currentEstimation = unwrappedOperator.elements.first!
        var eigenValueEstimation: Double = 1.0
        for _ in 0...nIterations {
            currentEstimation = (unwrappedOperator .* currentEstimation).normalized
            eigenValueEstimation = (unwrappedOperator .* currentEstimation).elements.first! / currentEstimation.elements.first! 
        }
        return [EigenPair(vector: currentEstimation, value: eigenValueEstimation)]
    }
}
