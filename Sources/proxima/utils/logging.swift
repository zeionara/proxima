import Logging

public func setupLogging(path: String? = nil, verbose: Bool, discardExistingLogFile: Bool) {
    if let pathUnwrapped = path {
        let augmentedPath = "assets/logs/\(pathUnwrapped).txt"
        
        makeSureFileExists(augmentedPath, recreate: discardExistingLogFile)
        LoggingSystem.bootstrap{ label in
            MultiplexLogHandler(
                [
                    FileLogHandler(level: verbose ? .trace : .info, label: label, path: augmentedPath),
                    StreamLogHandler.standardOutput(label: label)
                ]
            )
        }
    }
}

