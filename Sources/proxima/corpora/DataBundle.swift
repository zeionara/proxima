import Foundation

public extension URL{
    static func local(_ path: String) -> URL? {
        return Self(
            fileURLWithPath: FileManager.default.currentDirectoryPath
        ).appendingPathComponent(path)
    }
}

public class DataBundle<Element> where Element: DataBundleElement {
    public var elements: [Element]
    
    public init(_ elements: [Element]? = nil) {
        self.elements = elements ?? [Element]()
    }

    public var asTsv: String {
        let keys = Element.keys
        var lines = (
            [keys.joined(separator: "\t")] + elements.map{
                $0.getSerializedPropertyValues(keys, separator: "\t")
            }
        ).joined(separator: "\n")
        return lines
    }

    public func toTsv(_ path: String) {
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
