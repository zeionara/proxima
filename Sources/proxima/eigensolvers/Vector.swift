import Foundation

public struct Vector<Element: Numeric>: Operable where Element: CVarArg {
    public typealias Scalar = Element

    public let elements: [Scalar]
    public let columnar: Bool

    public init(_ elements: [Scalar], columnar: Bool = true) {
        assert(elements.count > 0)
        self.elements = elements
        self.columnar = columnar
    }

    public var T: Self {
        return Self(elements, columnar: !columnar)
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
        return Vector(elements.map{ $0 / norm })
    }

    public static func .*(lhs: Vector<Element>, rhs: Vector<Element>) -> Element {
        assert(!lhs.columnar && rhs.columnar)
        assert(lhs.elements.count == rhs.elements.count)
        return (0..<lhs.elements.count).map{
            lhs.elements[$0] * rhs.elements[$0]
        }.reduce(0, +)
    } 

    public static func -(lhs: Vector<Element>, rhs: Vector<Element>) -> Vector<Element> {
        assert(lhs.columnar == rhs.columnar)
        assert(lhs.elements.count == rhs.elements.count)
        return Vector<Element>(
            (0..<lhs.elements.count).map{ lhs.elements[$0] - rhs.elements[$0] },
            columnar: lhs.columnar
        )
    }


    public static func *(lhs: Vector<Element>, rhs: Vector<Element>) -> Vector<Element> {
        assert(lhs.columnar == rhs.columnar)
        assert(lhs.elements.count == rhs.elements.count)
        return Vector<Element>(
            (0..<lhs.elements.count).map{ lhs.elements[$0] * rhs.elements[$0] },
            columnar: lhs.columnar
        )
    }

    public static func +(lhs: Vector<Element>, rhs: Vector<Element>) -> Vector<Element> {
        assert(lhs.columnar == rhs.columnar)
        assert(lhs.elements.count == rhs.elements.count)
        return Vector(
            (0..<lhs.elements.count).map{ lhs.elements[$0] + rhs.elements[$0] },
            columnar: lhs.columnar
        )
    }


    public static func /(lhs: Vector<Element>, rhs: Vector<Element>) -> Vector<Element> {
        assert(lhs.columnar == rhs.columnar)
        assert(lhs.elements.count == rhs.elements.count)
        return Vector(
            (0..<lhs.elements.count).map{ lhs.elements[$0] / rhs.elements[$0] },
            columnar: lhs.columnar
        )
    }

    public static func /(lhs: Vector<Element>, rhs: Element) -> Vector<Element> {
        return Vector(
            (0..<lhs.elements.count).map{ lhs.elements[$0] / rhs },
            columnar: lhs.columnar
        )
    }

    public static func *(lhs: Element, rhs: Vector<Element>) -> Vector<Element> {
        return Vector(
            (0..<rhs.elements.count).map{ rhs.elements[$0] * lhs },
            columnar: rhs.columnar
        )
    }
}


extension Vector: CustomStringConvertible {
    public var description: String {
        "( \( self.elements.map{ String(format: "%.3f", $0) }.joined(separator: ", ") ) )" + (columnar ? " ^ T " : "")
    }
}

