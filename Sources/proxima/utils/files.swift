import Foundation

public extension URL{
    static func local(_ path: String) -> URL? {
        return Self(
            fileURLWithPath: FileManager.default.currentDirectoryPath
        ).appendingPathComponent(path)
    }
}


enum FileError: Error {
    case invalidPath(message: String)
}


public func getParentFolderPath(_ path: String) throws -> String  {
    let splits = String(path.reversed()).split(separator: "/", maxSplits: 1)
    if let parentFolderReversedPath = splits.last, splits.count == 2 {
        return String(parentFolderReversedPath.reversed())
    }
    throw FileError.invalidPath(message: "Cannot get parent folder from path \(path)")
}


public func makeSureParentFoldersExist(_ path: String) throws {
    let parentFolderPath = try getParentFolderPath(path)
    try FileManager.default.createDirectory(atPath: parentFolderPath, withIntermediateDirectories: true, attributes: nil)
}

public func makeSureFileExists(_ url: URL, recreate: Bool = false) {
    do {
        print("Check file exists, recreate = \(recreate)")
        if (!FileManager.default.fileExists(atPath: url.path) || recreate) {
            try Data("".utf8).write(to: url)
        }
    } catch {
        print("Cannot create file \(url) because of exception \(error)") 
    }
}


public func makeSureFileExists(_ path: String, recreate: Bool = false) {
    do{
        try makeSureParentFoldersExist(path)
    } catch {
        print("Cannot create parent folders for file \(path) because of exception \(error)")
    }
    
    if let fileURL = URL.local(path) { 
        makeSureFileExists(fileURL, recreate: recreate)
    } else {
        print("Cannot make sure that file \(path) exists because given path is not correct")
    }
}

