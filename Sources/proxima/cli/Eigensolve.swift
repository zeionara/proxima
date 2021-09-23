import ArgumentParser
import Logging

public struct Eigensolve: ParsableCommand {
    @Option(name: .shortAndLong, help: "Number of iterations to perform for eigenvatro (and eigenvalue search)")
    var accuracy: Int = 5

    @Flag(name: .shortAndLong, help: "Should output additional log entries which are considered pretty verbose")
    var verbose = false

    @Flag(name: .shortAndLong, help: "Discard contents of existing log file if any")
    var discardExistingLogFile = false

    @Option(name: .shortAndLong, help: "Name of logfile (if omitted then logs are written only to the standard output)")
    var logFileName: String?

    public static var configuration = CommandConfiguration(
        commandName: "eigen",
        abstract: "Basic eigenwavefunctions solver"
    )

    public init() {}

    mutating public func run() {
        let verboseLocal = verbose
        
        setupLogging(path: logFileName, verbose: verboseLocal, discardExistingLogFile: discardExistingLogFile) 

        let logger = Logger(level: verbose ? .trace : .info, label: "eigenvalue-analysis")


        let matrix = Matrix(
            [
                [ 2.92, 0.86, -1.15 ],
                [ 0.86, 6.51, 3.32 ],
                [ -1.15, 3.32, 4.57 ]
            ]
        )
 
        let solver = QRSolver()
        
        let eigenpairs = solver.solve(matrix, nIterations: accuracy)

        logger.info("Given matrix: \(matrix)")

        _ = eigenpairs.map { eigenpair in
            logger.info("")
            logger.info("Eigenvalue: \(eigenpair.value)")
            logger.info("Eigenvector: \(eigenpair.vector)")
            logger.trace("\(matrix) * \(eigenpair.vector) = \(matrix .* eigenpair.vector)")
        }
    }
}
