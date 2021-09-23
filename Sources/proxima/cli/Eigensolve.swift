import ArgumentParser

public struct Eigensolve: ParsableCommand {
    @Option(name: .shortAndLong, help: "Number of iterations to perform for eigenvatro (and eigenvalue search)")
    var accuracy: Int = 5

    public static var configuration = CommandConfiguration(
        commandName: "eigen",
        abstract: "Basic eigenwavefunctions solver"
    )

    public init() {}

    mutating public func run() {
        let matrix = Matrix(
            [
                [ 2.92, 0.86, -1.15 ],
                [ 0.86, 6.51, 3.32 ],
                [ -1.15, 3.32, 4.57 ]
            ]
        )
 
        let solver = QRSolver()
        
        let eigenpairs = solver.solve(matrix, nIterations: accuracy)

        print("Given matrix: \(matrix)")

        _ = eigenpairs.map { eigenpair in
            print("Eigenvalue: \(eigenpair.value)")
            print("Eigenvector: \(eigenpair.vector)")
            print("\(matrix) * \(eigenpair.vector) = \(matrix .* eigenpair.vector)")
        }
    }
}
