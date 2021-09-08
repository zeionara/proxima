import Foundation

public class DataBundle<Element>: TsvExportable where Element: DataBundleElement {
    public var elements: [Element]
    
    public init(_ elements: [Element]? = nil) {
        self.elements = elements ?? [Element]()
    }

    public var asTsv: String {
        let keys = Element.keys
        return (
            [keys.joined(separator: "\t")] + elements.map{
                $0.getSerializedPropertyValues(keys, separator: "\t")
            }
        ).joined(separator: "\n")
    }
}


public protocol DataBundleElement: Codable {
    static var keys: [String] { get }
    func getSerializedPropertyValue(_ name: String) -> String
    func getSerializedPropertyValues(_ names: [String], separator: String) -> String
}


public protocol TsvExportable {
    var asTsv: String { get }
    func toTsv(_ path: String)
}


public extension TsvExportable {
    func toTsv(_ path: String) {
        do {
            try makeSureParentFoldersExist(path)
        }  catch {
            print("Cannot make sure that parent folders exist due to exception: \(error.localizedDescription)")
            return
        }
        
        do {
            if let url = URL.local(path) {
                try asTsv.write(to: url, atomically: false, encoding: .utf8)
            } else {
                print("Path \(path) cannot be considered a valid url")    
            }
        } catch {
            print("Cannot save data bundle as tsv because of exception: \(error.localizedDescription)")
        }
    }
}


public extension DataBundleElement {
    func getSerializedPropertyValues(_ names: [String], separator: String = "\t") -> String {
        names.map{ getSerializedPropertyValue($0) }.joined(separator: separator)
    }
}


public protocol DataFrame: Codable {
    associatedtype Element: DataBundleElement

    var elements: [Element] { get }

    init(_ bundle: DataBundle<Element>)
}
