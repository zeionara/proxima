import Logging
import ArgumentParser

public struct Sample: ParsableCommand {
    @Flag(name: .shortAndLong, help: "Discard contents of existing log file if any")
    var discardExistingLogFile = false
    
    @Option(name: .shortAndLong, help: "Name of logfile (if omitted then logs are written only to the standard output)")
    var logFileName: String?

    @Option(name: .shortAndLong, help: "Number of samples to generate as command output")
    var nSamples: Int

    @Option(name: .shortAndLong, help: "Numerical degree of precision which must be considered when generating samples (the more this number the more precise and diverse results are obtained)")
    var precision: Int = 100

    @Option(name: .shortAndLong, help: "Number of workers to execute the sampling procedure (it is recommended to set it a little bit less than the number of physical core on your hardware)")
    var workers: Int = 2

    @Option(name: .shortAndLong, help: "Random numbers generator seed which allows you to guarantee the reproducibility of the results")
    var seed: Int?

    @Option(name: .shortAndLong, help: "Name of the output file which keeps generated values (if ommitted then results will be written to the standard output)")
    var outputFileName: String?

    @Flag(name: .shortAndLong, help: "Should output additional log entries which are considered pretty verbose")
    var verbose = false

    public init() {}

    mutating public func run() {
        let nSamplesLocal = nSamples 
        let precisionLocal = precision
        let nWorkersLocal = workers
        let seedLocal = seed
        let verboseLocal = verbose
        let outputFileNameLocal = outputFileName == nil ? nil : "assets/corpora/\(outputFileName!).tsv"

        setupLogging(path: logFileName, verbose: verboseLocal, discardExistingLogFile: discardExistingLogFile) 

        BlockingTask {
             measureExecutionTime("samples generation for 2d model of electrons in a potential well", accuracy: 5, verbose: verboseLocal) {
                 let wellModel = TwoDimensionalPotentialWellAnalyticModel(length: 2, width: 5)
                 let wavefunction = wellModel.getWaveFunction(n1: 1, n2: 1)
                 func getProbability(_ args: [Double]) -> Double {
                     return wavefunction(args.first!, args.last!) ** 2
                 }
         
                 func normalizeProbability(_ probability: Double, _ normalizationCoefficient: Double) -> Double {
                     return probability / normalizationCoefficient
                 }
         
                 let samples = await wellModel.getSamples(nSamplesLocal, nParts: nWorkersLocal, precision: precisionLocal, seed: seedLocal, verbose: verboseLocal).map{
                     TwoDimensionalElectronPosition(x: $0.first!, y: $0.last!)
                 }         

                 let bundle = DataBundle(seedLocal == nil ? samples : samples.sorted{ $0.x < $1.x }) 
                 if let outputFileNameLocalUnwrapped = outputFileNameLocal {
                     bundle.toTsv(outputFileNameLocalUnwrapped)
                 } else {
                     print(bundle.asTsv)
                 }
                 return nil
             }
         }
    }
}
