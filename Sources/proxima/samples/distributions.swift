import nest

func uniform(from: Double, to: Double, kind: GeneratorKind = .ceil) -> (Double) -> Double {
    func _uniform(x: Double) -> Double {
        if (
            ((kind == .ceil) && (x > from) && (x <= to)) || 
            ((kind == .floor) && (x >= from) && (x < to))
        ) {
            return 1 / (to - from)
        }
        return 0.0
    }
    
    return _uniform
}
