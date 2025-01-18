extension Array  {
    
    func contains<T: Equatable, U: Equatable>(_ tuple: Element) -> Bool where Element == (T, U) {
        return contains{tuple.0 == $0.0 && tuple.1 == $0.1}
    }
    
    func areObjectivesEqual(_ lhs: [(Bool, String)], _ rhs: [(Bool, String)]) -> Bool {
        guard lhs.count == rhs.count else { return false }
        for (index, objective) in lhs.enumerated() {
            if objective.0 != rhs[index].0 || objective.1 != rhs[index].1 {
                return false
            }
        }
        return true
    }
}

extension Array where Element == (Bool, String) {
    func isEqual(to other: [(Bool, String)]) -> Bool {
        guard self.count == other.count else { return false }
        for (index, element) in self.enumerated() {
            if element.0 != other[index].0 || element.1 != other[index].1 {
                return false
            }
        }
        return true
    }
}
