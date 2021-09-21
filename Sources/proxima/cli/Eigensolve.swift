import ArgumentParser

public struct Eigensolve: ParsableCommand {
    // @Flag(name: .shortAndLong, help: "Discard contents of existing log file if any")
    // var discardExistingLogFile = false
    // 
    // @Option(name: .shortAndLong, help: "Name of logfile (if omitted then logs are written only to the standard output)")
    // var logFileName: String?

    // @Option(name: .shortAndLong, help: "Number of samples to generate as command output")
    // var nSamples: Int

    // @Option(name: .shortAndLong, help: "Numerical degree of precision which must be considered when generating samples (the more this number the more precise and diverse results are obtained)")
    // var precision: Int = 100

    @Option(name: .shortAndLong, help: "Number of iterations to perform for eigenvatro (and eigenvalue search)")
    var accuracy: Int = 5

    // @Option(name: .shortAndLong, help: "Random numbers generator seed which allows you to guarantee the reproducibility of the results")
    // var seed: Int?

    // @Option(name: .shortAndLong, help: "Name of the output file which keeps generated values (if ommitted then results will be written to the standard output)")
    // var outputFileName: String?

    // @Flag(name: .shortAndLong, help: "Should output additional log entries which are considered pretty verbose")
    // var verbose = false

    public static var configuration = CommandConfiguration(
        commandName: "eigen",
        abstract: "Basic eigenwavefunctions solver"
    )

    public init() {}

    mutating public func run() {
        print("matrix multiplication demo: ")
        // let matrix = Matrix([Vector(elements: [1.0, 0.0], columnar: false), Vector(elements: [0.0, 2.0], columnar: false)])
        let matrix = Matrix([Vector(elements: [1.1, 2.0], columnar: false), Vector(elements: [0.7, 2.7], columnar: false)])
        let solver = LinearEigensolver()
        let solution = solver.solve(matrix, nIterations: accuracy)
        // let inputVector = Vector(elements: [1.0, 1.1])
        // print("\(matrix) . \(inputVector) = \(matrix .* inputVector)")
        print("\(solution) is a solution for matrix \(matrix)")
    }
}
