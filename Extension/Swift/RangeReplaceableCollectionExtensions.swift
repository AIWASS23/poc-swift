import Foundation

extension RangeReplaceableCollection {
    /// Creates a new collection of a given size where for each position of the collection the value will
    /// be the result of a call of the given expression.
    ///
    ///     let values = Array(expression: "Value", count: 3)
    ///     print(values)
    ///     // Prints "["Value", "Value", "Value"]"
    
    init(expression: @autoclosure () throws -> Element, count: Int) rethrows {
        self.init()
        if count > 0 {
            reserveCapacity(count)
            while self.count < count {
                try append(expression())
            }
        }
    }
}

extension RangeReplaceableCollection {
    // Returns a new rotated collection by the given places.
    ///
    ///     [1, 2, 3, 4].rotated(by: 1) -> [4,1,2,3]
    ///     [1, 2, 3, 4].rotated(by: 3) -> [2,3,4,1]
    ///     [1, 2, 3, 4].rotated(by: -1) -> [2,3,4,1]
    ///
   
    func rotated(by places: Int) -> Self {
        var copy = self
        return copy.rotate(by: places)
    }

    // Rotate the collection by the given places.
    ///
    ///     [1, 2, 3, 4].rotate(by: 1) -> [4,1,2,3]
    ///     [1, 2, 3, 4].rotate(by: 3) -> [2,3,4,1]
    ///     [1, 2, 3, 4].rotated(by: -1) -> [2,3,4,1]
    ///
    
    @discardableResult
    mutating func rotate(by places: Int) -> Self {
        guard places != 0 else { return self }
        let placesToMove = places % count
        if placesToMove > 0 {
            let range = index(endIndex, offsetBy: -placesToMove)...
            let slice = self[range]
            removeSubrange(range)
            insert(contentsOf: slice, at: startIndex)
        } else {
            let range = startIndex..<index(startIndex, offsetBy: -placesToMove)
            let slice = self[range]
            removeSubrange(range)
            append(contentsOf: slice)
        }
        return self
    }

    // Removes the first element of the collection which satisfies the given predicate.
    ///
    ///        [1, 2, 2, 3, 4, 2, 5].removeFirst { $0 % 2 == 0 } -> [1, 2, 3, 4, 2, 5]
    ///        ["h", "e", "l", "l", "o"].removeFirst { $0 == "e" } -> ["h", "l", "l", "o"]
    ///
    
    @discardableResult
    mutating func removeFirst(where predicate: (Element) throws -> Bool) rethrows -> Element? {
        guard let index = try firstIndex(where: predicate) else { return nil }
        return remove(at: index)
    }

    @discardableResult
    mutating func removeRandomElement() -> Element? {
        guard let randomIndex = indices.randomElement() else { return nil }
        return remove(at: randomIndex)
    }

    // Keep elements of Array while condition is true.
    ///
    ///        [0, 2, 4, 7].keep(while: { $0 % 2 == 0 }) -> [0, 2, 4]
    ///
    
    @discardableResult
    mutating func keep(while condition: (Element) throws -> Bool) rethrows -> Self {
        if let idx = try firstIndex(where: { try !condition($0) }) {
            removeSubrange(idx...)
        }
        return self
    }

    // Take element of Array while condition is true.
    ///
    ///        [0, 2, 4, 7, 6, 8].take( where: {$0 % 2 == 0}) -> [0, 2, 4]
    ///
    
    func take(while condition: (Element) throws -> Bool) rethrows -> Self {
        return try Self(prefix(while: condition))
    }

    // Skip elements of Array while condition is true.
    ///
    ///        [0, 2, 4, 7, 6, 8].skip( where: {$0 % 2 == 0}) -> [6, 8]
    ///

    func skip(while condition: (Element) throws -> Bool) rethrows -> Self {
        guard let idx = try firstIndex(where: { try !condition($0) }) else { return Self() }
        return Self(self[idx...])
    }

    // Remove all duplicate elements using KeyPath to compare.
    
    mutating func removeDuplicates<E: Equatable>(keyPath path: KeyPath<Element, E>) {
        var items = [Element]()
        removeAll { element -> Bool in
            guard items.contains(where: { $0[keyPath: path] == element[keyPath: path] }) else {
                items.append(element)
                return false
            }
            return true
        }
    }

    // Remove all duplicate elements using KeyPath to compare.
    
    mutating func removeDuplicates<E: Hashable>(keyPath path: KeyPath<Element, E>) {
        var set = Set<E>()
        removeAll { !set.insert($0[keyPath: path]).inserted }
    }

    // Accesses the element at the specified position.
   
    subscript(offset: Int) -> Element {
        get {
            return self[index(startIndex, offsetBy: offset)]
        }
        set {
            let offsetIndex = index(startIndex, offsetBy: offset)
            replaceSubrange(offsetIndex..<index(after: offsetIndex), with: [newValue])
        }
    }

    // Accesses a contiguous subrange of the collection’s elements.
   
    subscript<R>(range: R) -> SubSequence where R: RangeExpression, R.Bound == Int {
        get {
            let indexRange = range.relative(to: 0..<count)
            return self[index(startIndex, offsetBy: indexRange.lowerBound)..<index(startIndex,
                                                                                   offsetBy: indexRange.upperBound)]
        }
        set {
            let indexRange = range.relative(to: 0..<count)
            replaceSubrange(
                index(startIndex, offsetBy: indexRange.lowerBound)..<index(startIndex, offsetBy: indexRange.upperBound),
                with: newValue)
        }
    }

    /*
    Adds a new element at the end of the array, mutates the array in place
    */
    mutating func appendIfNonNil(_ newElement: Element?) {
        guard let newElement = newElement else { return }
        append(newElement)
    }

    /*
    Adds the elements of a sequence to the end of the array, mutates the array in place
    */
    mutating func appendIfNonNil<S>(contentsOf newElements: S?) where Element == S.Element, S: Sequence {
        guard let newElements = newElements else { return }
        append(contentsOf: newElements)
    }
}
