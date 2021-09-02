import nest
import Foundation

print(
    OneDimensionalPotentialWellAnalyticModel(length: 5).sample(10)
)

BlockingTask {
    print(
        await OneDimensionalPotentialWellAnalyticModel(length: 5).sample(10, nParts: 3)
    )
}

measureExecutionTime("sphere volume computation using hardcoded implementation") {
    print(
        computeSphereVolumeUsingCartesianSystem(
            5,
            precision: 2000
        )
    )
}

measureExecutionTime("sphere volume computation explicit multivariable integration") {
    print(
        computeSphereVolumeViaExplicitMultivariateIntegration(
            5,
            precision: 2000
        )
    )
}
