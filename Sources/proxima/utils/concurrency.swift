import Foundation

extension DispatchGroup {
    public func enter(_ nWorkers: Int) {
        for i in 0..<nWorkers {
            self.enter()
        }
    }
}
