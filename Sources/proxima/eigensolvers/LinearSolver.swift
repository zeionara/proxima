import Foundation

infix operator .*: MultiplicationPrecedence // Dot product operator which is generally defined as tensor-to-tensor multiplications

public struct Vector<Element: Numeric>: Operable where Element: CVarArg {
    public typealias Scalar = Element

    public let elements: [Scalar]
    public let columnar: Bool

    public init(elements: [Scalar], columnar: Bool = true) {
        assert(elements.count > 0)
        self.elements = elements
        self.columnar = columnar
    }

}

extension Vector where Element == Double {
    public var norm: Element {
        let squares: [Element] = elements.map{
            pow($0, 2.0)
        }
        let reducedSum: Double = squares.reduce(0, +)
        return reducedSum.squareRoot()
    }

    public var normalized: Vector {
        return Vector(elements: elements.map{ $0 / norm })
    }

    public static func .*(lhs: Vector<Element>, rhs: Vector<Element>) -> Element {
        assert(!lhs.columnar && rhs.columnar)
        assert(lhs.elements.count == rhs.elements.count)
        return (0..<lhs.elements.count).map{
            lhs.elements[$0] * rhs.elements[$0]
        }.reduce(0, +)
    } 
}


extension Vector: CustomStringConvertible {
    public var description: String {
        "( \( self.elements.map{ String(format: "%.3f", $0) }.joined(separator: ", ") ) )" + (columnar ? " ^ T " : "")
    }
}

public struct Matrix<Element: Numeric>: Operator where Element: CVarArg {
    public typealias OperableType = Vector<Element>

    public let elements: [OperableType]

    public init(_ elements: [OperableType]) {
        assert(elements.count > 0)
        self.elements = elements
    }

    public func apply(_ operable: OperableType) -> OperableType {
        transformVector(
            self,
            operable
        )
    }

    public static func .*(lhs: Matrix<Element>, rhs: Vector<Element>) -> Vector<Element> {
        assert(rhs.columnar) // Row-vectors cannot be multiplied by matrix because number of columns in one object and number of rows in the other may not differ
        assert(rhs.elements.count == lhs.elements.first!.elements.count)
        return lhs.apply(rhs) 
    } 


}

extension Matrix: CustomStringConvertible {
    public var description: String {
        "( \( self.elements.map{ $0.description }.joined(separator: ", ") ) )"
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
