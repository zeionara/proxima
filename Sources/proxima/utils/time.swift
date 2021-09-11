import Foundation
import Logging

public func traceExecutionTime<Type>(_ label: String, _ function: () async -> Type, generateResultDependentSuffix: Optional<(Type) -> String> = .none) async -> Type {
    let start = DispatchTime.now()
    let result = await function()
    let end = DispatchTime.now()
    let nSeconds = Double(end.uptimeNanoseconds - start.uptimeNanoseconds) / 1_000_000_000

    var suffix = ""
    if let generateResultDependentSuffix_ = generateResultDependentSuffix {
        suffix = "; \(generateResultDependentSuffix_(result))"
    }

    print("\(label) has completed in \(String(format: "%.3f", nSeconds)) seconds\(suffix)")
    return result
}

public func traceExecutionTimeAndAbsoluteError(_ label: String, ref referenceValue: Double, _ function: () async -> Double) async -> Double {
    return await traceExecutionTime(label, function) { integrationResult in
        "absolute error: \(String(format: "%.5f", abs(integrationResult - referenceValue) / referenceValue))"
    }
}

public func testPerformanceAndPrecision(min minPrecision: Int, max maxPrecision: Int, step: Int, label: String, ref referenceValue: Double, function: (Int) async -> Double) async -> [Double] {
    var result = [Double]()
    for precision in stride(from: minPrecision, to: maxPrecision + 1, by: step) {
        print("precision = \(precision)")
        result.append(
            await traceExecutionTimeAndAbsoluteError(label, ref: referenceValue) {
                return await function(precision)
            }
        )
    }
    return result
}

//public class FileLogger: LogHandler {
//    public subscript(metadataKey _: String) -> Logger.Metadata.Value? {
//        get {
//            
//        }
//        set(newValue) {
//            <#code#>
//        }
//    }
//
//    public var metadata: Logger.Metadata
//
//    public var logLevel: Logger.Level
//
//    let outputPath: String?
//    var logger: Logger
//
//    init(level: Logger.Level = .info, label: String, path: String? = nil) {
//        logger = Logger(label: label)
//        logger.logLevel = level
//
//        if let unwrappedPath = path {
//            makeSureParentFoldersExist(unwrappedPath)
//            outputPath = unwrappedPath
//        } else {
//            outputPath = nil
//        }
//    }
//}

public extension Logger {
     // let outputPath: String?
     // var logger: Logger
        
    init(level: Logger.Level = .info, label: String) {
        self.init(label: label)
        logLevel = level

        // if let unwrappedPath = path {
        //     makeSureParentFoldersExist(unwrappedPath)
        //     outputPath = unwrappedPath
        // } else {
        //     outputPath = nil
        // }
    }
}

public extension String {
    func append(_ url: URL, ensureFileExists: Bool = true) {
        if ensureFileExists {
            makeSureFileExists(url)
        }
        
        do {
            // print(url)
            let fileHandle = try FileHandle(forWritingTo: url)
            fileHandle.seekToEndOfFile()
            // convert your string to data or load it from another resource
            // let str = "Line 1\nLine 2\n"
            let textData = Data(self.utf8)
            // append your text to your text file
            fileHandle.write(textData)
            // close it when done
            fileHandle.closeFile()
            // testing/reading the file edited
            // if let text = try? String(contentsOf: fileURL, encoding: .utf8) {
            //     print(text)  // "Hello World\nLine 1\nLine 2\n\n"
            // }
        } catch {
            print("Cannot append to file due to exception \(error)")
        }    
    }

    func append(_ path: String, ensureFileExists: Bool = true) {
        // print(path)
        if ensureFileExists {
            makeSureFileExists(path)
        } 
        
        if let url = URL.local(path) {
            append(url, ensureFileExists: false)
        } else {
            print("Cannot write to file \(path) because of invalid url")
        }
    }
}


public struct FileLogHandler: LogHandler {
    ///// Factory that makes a `StreamLogHandler` to directs its output to `stdout`
    //public static func standardOutput(label: String) -> StreamLogHandler {
    //    return StreamLogHandler(label: label, stream: StdioOutputStream.stdout)
    //}

    ///// Factory that makes a `StreamLogHandler` to directs its output to `stderr`
    //public static func standardError(label: String) -> StreamLogHandler {
    //    return StreamLogHandler(label: label, stream: StdioOutputStream.stderr)
    //}

    private let path: String
    private let label: String
    public var logLevel: Logger.Level

    private var prettyMetadata: String?
    public var metadata = Logger.Metadata() {
        didSet {
            self.prettyMetadata = self.prettify(self.metadata)
        }
    }

    public subscript(metadataKey metadataKey: String) -> Logger.Metadata.Value? {
        get {
            return self.metadata[metadataKey]
        }
        set {
            self.metadata[metadataKey] = newValue
        }
    }

    // internal for testing only
    // internal init(label: String, stream: TextOutputStream) {
    //     self.stream = stream
    // }

    init(level: Logger.Level?, label: String, path: String) {
        if let unwrappedLevel = level {
            logLevel = unwrappedLevel
        } else {
            print("Use default log lgevel")
            logLevel = .info
        }
        self.label = label
        self.path = path // URL.local(path)!
    }

    public func log(level: Logger.Level, message: Logger.Message, metadata: Logger.Metadata?, file: String, function: String, line: UInt) {
        let prettyMetadata = metadata?.isEmpty ?? true ? self.prettyMetadata : self.prettify(self.metadata.merging(metadata!, uniquingKeysWith: { _, new in new }))
        "\(self.timestamp()) \(level) \(label):\(prettyMetadata.map { " \($0)" } ?? "") \(message)\n".append(path)
    }

    private func prettify(_ metadata: Logger.Metadata) -> String? {
        return !metadata.isEmpty ? metadata.map { "\($0)=\($1)" }.joined(separator: " ") : nil
    }

    private func timestamp() -> String {
        var buffer = [Int8](repeating: 0, count: 255)
        var timestamp = time(nil)
        let localTime = localtime(&timestamp)
        strftime(&buffer, buffer.count, "%Y-%m-%dT%H:%M:%S%z", localTime)
        return buffer.withUnsafeBufferPointer {
            $0.withMemoryRebound(to: CChar.self) {
                String(cString: $0.baseAddress!)
            }
        }
    }
}



public func measureExecutionTime(_ label: String, accuracy: Int = 3, apply closure: @escaping () async -> String?) {
    let group = DispatchGroup()
    group.enter(1)
    let start = DispatchTime.now()

    Task {
        let logger = Logger(level: .trace, label: "execution-time-measuring")
        // logger.logLevel = .trace
        logger.trace("Starting \(label)...")
        let closureExecutionResult = await closure()
        let end = DispatchTime.now()
        let nSeconds = Double(end.uptimeNanoseconds - start.uptimeNanoseconds) / 1_000_000_000
        logger.info("Completed \(label) in \(String(format: "%.\(accuracy)f", nSeconds)) seconds \(closureExecutionResult ?? "")")
        group.leave()
    }

    group.wait()
}
