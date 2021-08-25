import nest
import Foundation

print("Compute sphere volume using z-axis + polar coordinates:")
print()

testPerformanceAndPrecision(
    min: 100, max: 1000, step: 100, label: "sphere volume computation", ref: 4.0 / 3.0 * Double.pi * 8.0
) { precision in
    computeSphereVolume(2.0, precision: precision, kind: .right)
}

print()
print("Compute sphere volume using cartesian system:")
print()

testPerformanceAndPrecision(
    min: 100, max: 1000, step: 100, label: "sphere volume computation", ref: 4.0 / 3.0 * Double.pi * 8.0
) { precision in
    computeSphereVolumeUsingCartesianSystem(2.0, precision: precision, kind: .right)
}
