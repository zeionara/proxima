import Foundation

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
