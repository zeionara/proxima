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
        assert(nIterations >= 0)
        let unwrappedSolvedOperator = solvedOperator!

        // Find eigenvalues

        var qrDecomposition = unwrappedSolvedOperator.qrDecomposition

        for _ in 0..<nIterations {
            qrDecomposition = (qrDecomposition.r .* qrDecomposition.q).qrDecomposition
        }

        let eigenvalues = (qrDecomposition.q .* qrDecomposition.r).diagonal.elements

        // Find eigenvectors

        qrDecomposition = solvedOperator!.qrDecomposition

        for _ in 0..<nIterations {
            qrDecomposition = (unwrappedSolvedOperator .* qrDecomposition.q).qrDecomposition
        }

        return zip(qrDecomposition.q.columns, eigenvalues).map { (eigenvector, eigenvalue) in
            EigenPair(vector: eigenvector, value: eigenvalue)
        } 
    }
}
