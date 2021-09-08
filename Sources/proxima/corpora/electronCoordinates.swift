public struct TwoDimensionalElectronPosition: DataBundleElement {
    public let x: Double
    public let y: Double

    enum CodingKeys: String, CodingKey, CaseIterable {
        case x = "x"
        case y = "y"
    }

    public func getSerializedPropertyValue(_ name: String) -> String {
        switch name {
            case "x": return String(format:"%.5f", x)
            case "y": return String(format:"%.5f", y)
            default: fatalError("Wrong property name")
        }
    }

    public static var keys: [String] {
        return CodingKeys.allCases.map{ $0.rawValue }
    }
}

public struct TwoDimensionalElectronPositionDataFrame: DataFrame {
    public typealias Element = TwoDimensionalElectronPosition

    public let x: [Double]
    public let y: [Double]

    public var asTsv: String {
        (
            [Element.keys.joined(separator: "\t")] + (0..<x.count).map{
                [
                    String(format: "%.5f", x[$0]),
                    String(format: "%.5f", y[$0])
                ].joined(separator: "\t")
            }
        ).joined(separator: "\n")
    }

    public var elements: [TwoDimensionalElectronPosition] {
        (0..<x.count).map{
            TwoDimensionalElectronPosition(
                x: x[$0], y: y[$0]
            )
        }
    }

    public init(_ bundle: DataBundle<Element>) {
        var x = [Double]()
        var y = [Double]()

        for element in bundle.elements {
            x.append(element.x)
            y.append(element.x)
        }

        self.x = x
        self.y = y
    }
}
