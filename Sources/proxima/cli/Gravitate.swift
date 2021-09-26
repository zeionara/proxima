import ArgumentParser
import Logging

public enum ParticleKind {
    case fermion(_ spin: Double)
    case boson(_ spin: Double)
}

public struct SpinEdge {
    public let spin: Double
    
    public init(_ spin: Double = 0.0) {
        let remainder = spin.truncatingRemainder(dividingBy: 1)
        assert(spin > 0 && (remainder == 0.5 || remainder == 0), "Spin can take only positive integer or half-integer values!")
        self.spin = spin
    }

    public var kind: ParticleKind {
        if abs(spin.truncatingRemainder(dividingBy: 1)) == 0.5 {
            return ParticleKind.fermion(spin)
        } else {
            return ParticleKind.boson(spin)
        }
    }
}

public struct SpinVertex {
    public let a: SpinEdge
    public let b: SpinEdge
    public let c: SpinEdge 

    public init(_ a: SpinEdge, _ b: SpinEdge, _ c: SpinEdge) {
        assert(a.spin + b.spin >= c.spin && b.spin + c.spin >= a.spin && a.spin + c.spin >= b.spin, "The spins do not satisfy triangle inequalities")
        self.a = a
        self.b = b
        self.c = c
    }

    public var i: Double {
        (a.spin + c.spin - b.spin) / 2.0
    }

    public var j: Double {
        (b.spin + c.spin - a.spin) / 2.0
    }

    public var k: Double {
        (a.spin + b.spin - c.spin) / 2.0
    }

}

public class SpinNetwork {
    public var vertices: [SpinVertex]
    
    public init(_ vertices: [SpinVertex]?) {
        self.vertices = vertices ?? [SpinVertex]()
    }
}

public struct Gravitate: ParsableCommand {
    @Flag(name: .shortAndLong, help: "Should output additional log entries which are considered pretty verbose")
    var verbose = false

    @Flag(name: .shortAndLong, help: "Discard contents of existing log file if any")
    var discardExistingLogFile = false

    @Option(name: .shortAndLong, help: "Name of logfile (if omitted then logs are written only to the standard output)")
    var logFileName: String?

    public static var configuration = CommandConfiguration(
        commandName: "lqg",
        abstract: "Run loop quantum gravity numerical experiments"
    )

    public init() {}

    mutating public func run() {
        let verboseLocal = verbose
        
        setupLogging(path: logFileName, verbose: verboseLocal, discardExistingLogFile: discardExistingLogFile) 

        let logger = Logger(level: verbose ? .trace : .info, label: "eigenvalue-analysis")

        logger.trace("Say hello to quantum gravity models!")

        let network = SpinNetwork(
            [
                SpinVertex(
                    SpinEdge(1.0),
                    SpinEdge(1.5),
                    SpinEdge(2.0)
                )
            ]
        )

        logger.info("Value of i property of a vertex in a simple spin network: \(network.vertices.first!.i)")
    }
}
