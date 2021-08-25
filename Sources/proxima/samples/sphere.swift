import nest

// 1st approach - use z axis and angle

public func computeCircleSquare(_ r: Double, precision: Int = 10000, kind: IntegralKind = .right) -> Double {
    return 2.0 * integrate( { (fi: Double) -> Double in
            return r
        },
        from: 0,
        to: Double.pi,
        precision: precision,
        kind: kind
    )
}

public func computeSphereVolume(_ r: Double, precision: Int = 10000, kind: IntegralKind = .right) -> Double {
    return 2.0 * integrate( { (x: Double) -> Double in
            let difference = r*r - x*x
            let sqrt = difference > 0 ? difference.squareRoot() : 0
            return computeCircleSquare(
                sqrt,
                precision: precision,
                kind: kind
            )
        },
        from: 0,
        to: r,
        precision: precision,
        kind: kind
    )
}

// 2nd approach - use x and y coordinates

public func computeElementarySphereSquare(_ r: Double, x: Double, precision: Int = 10000, kind: IntegralKind = .right) -> Double {
    return 2.0 * integrate( { (y: Double) -> Double in
            let value = r*r - (x*x + y*y)
            return value > 0 ? value.squareRoot() : 0.0 
        },
        from: 0,
        to: r,
        precision: precision,
        kind: kind
    )
}

public func computeSphereVolumeUsingCartesianSystem(_ r: Double, precision: Int = 10000, kind: IntegralKind = .right) -> Double {
    return 4.0 * integrate( { (x: Double) -> Double in
            return computeElementarySphereSquare(
                r,
                x: x,
                precision: precision,
                kind: kind
            )
        },
        from: 0,
        to: r,
        precision: precision,
        kind: kind
    )
}