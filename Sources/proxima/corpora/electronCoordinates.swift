public protocol DataBundleElement: Codable {
    static var keys: [String] { get }
    func getSerializedPropertyValue(_ name: String) -> String
    func getSerializedPropertyValues(_ names: [String], separator: String) -> String
}

public extension DataBundleElement {
    func getSerializedPropertyValues(_ names: [String], separator: String = "\t") -> String {
        names.map{ getSerializedPropertyValue($0) }.joined(separator: separator)
    }
}

public struct TwoDimensionalElectronPosition: DataBundleElement {
    public let x: Double
    public let y: Double

    enum CodingKeys: String, CodingKey, CaseIterable {
        case x = "x"
        case y = "y"
    }

    public static var keys: [String] {
        return CodingKeys.allCases.map{ $0.rawValue }
    }

    public func getSerializedPropertyValue(_ name: String) -> String {
        switch name {
            case "x": return String(format:"%.5f", x)
            case "y": return String(format:"%.5f", y)
            default: fatalError("Wrong property name")
        }
    }
}
