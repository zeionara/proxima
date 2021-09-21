import Foundation

infix operator .*: MultiplicationPrecedence // Dot product operator which is generally defined as tensor-to-tensor multiplications

extension Array where Element == Array<Double> {
    public var T: Self {
        var columnData: [[Element.Element]] = Array(repeating: [Element.Element](), count: self.first!.count)

        for row in self {
           _ = row.enumerated().map{ i, cell in
              columnData[i].append(cell)
           }
        } 

        return columnData
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

    public var columns: [OperableType] {
        var columnData: [[Element]] = Array(repeating: [Element](), count: self.elements.first!.elements.count)

        for row in self.elements {
           _ = row.elements.enumerated().map{ i, cell in
              columnData[i].append(cell)
           }
        } 

        return columnData.map{
            OperableType(elements: $0, columnar: true)
        }
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

public typealias QRFactorizationResult<Element: Numeric> = (q: Matrix<Element>, r: Matrix<Element>) where Element: CVarArg

extension Matrix where Element == Double {
    public var qrDecomposition: QRFactorizationResult<Element> {
        var normalizedFactors = [OperableType]()
        var triangularMatrixColumns = [OperableType]()

        _ = columns.enumerated().map{ i, column in
            var triangularMatrixColumnData = [Element]()
            let u = column - (0..<i).map{
                let scale: Element = (columns[$0].T .* normalizedFactors[$0])
                triangularMatrixColumnData.append(scale) 

                return scale * normalizedFactors[$0]}.reduce(
                Vector(elements: Array(repeating: 0.0, count: elements.first!.elements.count), columnar: true),
                +
            )
            triangularMatrixColumnData.append(column.T .* u)
            for _ in 0..<column.elements.count - triangularMatrixColumnData.count {
               triangularMatrixColumnData.append(0.0)
            } 

            triangularMatrixColumns.append(Vector(elements: triangularMatrixColumnData, columnar: true)) 
            normalizedFactors.append(u / u.norm)
        }

        let postProcessedNormalizedFactors: [OperableType] = normalizedFactors.map{$0.elements}.T.map{
            Vector(elements: $0, columnar: false)
        }
        return QRFactorizationResult(
            q: Matrix(
                postProcessedNormalizedFactors
            ),
            r: Matrix(
                triangularMatrixColumns.map{$0.elements}.T.map{
                    Vector(elements: $0, columnar: false)
                }
            )
        )
    }
}
