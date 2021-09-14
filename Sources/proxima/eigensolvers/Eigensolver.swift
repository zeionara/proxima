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

    func solve<PairOperableType>(_ operator: OperatorType) -> Array<EigenPair<PairOperableType>> where PairOperableType == OperatorType.OperableType
}

public struct Vector<Element: Numeric>: Operable {
    public typealias Scalar = Element

    public let elements: [Scalar]

    public init(elements: [Scalar]) {
        assert(elements.count > 0)
        self.elements = elements
    }
}

public struct Matrix<Element: Numeric>: Operator {
    public typealias OperableType = Vector<Element>

    public let elements: [OperableType]

    public init(_ elements: [OperableType]) {
        assert(elements.count > 0)
        self.elements = elements
    }

    public func apply(_ operable: OperableType) -> OperableType {
        return transformVector(
            self,
            operable
        )
        // return operable.elements.first! * elements.first!.elements.first!
    }
}

public func transformVector<Element: Numeric>(_ matrix: Matrix<Element>, _ vector: Vector<Element>) -> Vector<Element> {
   var elements = [Element]()

   for row in matrix.elements {
        elements.append(
            vector.elements.enumerated().map{ (i, vectorItem) in
               vectorItem * row.elements[i] 
            }.reduce(0, +)
        )
   } 

   return Vector(elements: elements)
}
