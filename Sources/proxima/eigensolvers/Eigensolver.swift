public typealias EigenPair<OperableType: Operable> = (vector: OperableType, value: OperableType.Scalar)

public protocol Operable {
    associatedtype Scalar: Numeric
}

public protocol Operator {
    associatedtype OperableType: Operable

    func apply(_ operable: OperableType) -> OperableType
}

public protocol Eigensolver {
    associatedtype OperatorType: Operator

    func solve<PairOperableType>(_ solvedOperator: OperatorType?, nIterations: Int) -> Array<EigenPair<PairOperableType>> where PairOperableType == OperatorType.OperableType
}

