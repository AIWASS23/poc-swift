import Foundation

extension Sequence {
    // Check if all elements in collection match a condition.
    ///
    ///        [2, 2, 4].all(matching: {$0 % 2 == 0}) -> true
    ///        [1,2, 2, 4].all(matching: {$0 % 2 == 0}) -> false
    
    func all(matching condition: (Element) throws -> Bool) rethrows -> Bool {
        return try !contains { try !condition($0) }
    }

    // Check if no elements in collection match a condition.
    ///
    ///        [2, 2, 4].none(matching: {$0 % 2 == 0}) -> false
    ///        [1, 3, 5, 7].none(matching: {$0 % 2 == 0}) -> true
    ///
    
    func none(matching condition: (Element) throws -> Bool) rethrows -> Bool {
        return try !contains { try condition($0) }
    }

    // Check if any element in collection match a condition.
    ///
    ///        [2, 2, 4].any(matching: {$0 % 2 == 0}) -> false
    ///        [1, 3, 5, 7].any(matching: {$0 % 2 == 0}) -> true
    
    func any(matching condition: (Element) throws -> Bool) rethrows -> Bool {
        return try contains { try condition($0) }
    }

    // Filter elements based on a rejection condition.
    ///
    ///        [2, 2, 4, 7].reject(where: {$0 % 2 == 0}) -> [7]

    func reject(where condition: (Element) throws -> Bool) rethrows -> [Element] {
        return try filter { return try !condition($0) }
    }

    // Get element count based on condition.
    ///
    ///        [2, 2, 4, 7].count(where: {$0 % 2 == 0}) -> 3
    
    func count(where condition: (Element) throws -> Bool) rethrows -> Int {
        var count = 0
        for element in self where try condition(element) {
            count += 1
        }
        return count
    }

    // Iterate over a collection in reverse order. (right to left)
    ///
    ///        [0, 2, 4, 7].forEachReversed({ print($0)}) -> // Order of print: 7,4,2,0
    
    func forEachReversed(_ body: (Element) throws -> Void) rethrows {
        try reversed().forEach(body)
    }

    // Calls the given closure with each element where condition is true.
    ///
    ///        [0, 2, 4, 7].forEach(where: {$0 % 2 == 0}, body: { print($0)}) -> // print: 0, 2, 4
   
    func forEach(where condition: (Element) throws -> Bool, body: (Element) throws -> Void) rethrows {
        try lazy.filter(condition).forEach(body)
    }

    // Reduces an array while returning each interim combination.
    ///
    ///     [1, 2, 3].accumulate(initial: 0, next: +) -> [1, 3, 6]
   
    func accumulate<U>(initial: U, next: (U, Element) throws -> U) rethrows -> [U] {
        var runningTotal = initial
        return try map { element in
            runningTotal = try next(runningTotal, element)
            return runningTotal
        }
    }

    // Filtered and map in a single operation.
    ///
    ///     [1,2,3,4,5].filtered({ $0 % 2 == 0 }, map: { $0.string }) -> ["2", "4"]
    ///
    
    func filtered<T>(_ isIncluded: (Element) throws -> Bool, map transform: (Element) throws -> T) rethrows -> [T] {
        return try lazy.filter(isIncluded).map(transform)
    }

    // Get the only element based on a condition.
    ///
    ///     [].single(where: {_ in true}) -> nil
    ///     [4].single(where: {_ in true}) -> 4
    ///     [1, 4, 7].single(where: {$0 % 2 == 0}) -> 4
    ///     [2, 2, 4, 7].single(where: {$0 % 2 == 0}) -> nil
    
    func single(where condition: (Element) throws -> Bool) rethrows -> Element? {
        var singleElement: Element?
        for element in self where try condition(element) {
            guard singleElement == nil else {
                singleElement = nil
                break
            }
            singleElement = element
        }
        return singleElement
    }

    // Remove duplicate elements based on condition.
    ///
    ///        [1, 2, 1, 3, 2].withoutDuplicates { $0 } -> [1, 2, 3]
    ///        [(1, 4), (2, 2), (1, 3), (3, 2), (2, 1)].withoutDuplicates { $0.0 } -> [(1, 4), (2, 2), (3, 2)]
   
    func withoutDuplicates<T: Hashable>(transform: (Element) throws -> T) rethrows -> [Element] {
        var set = Set<T>()
        return try filter { try set.insert(transform($0)).inserted }
    }

    //  Separates all items into 2 lists based on a given predicate. The first list contains all items
    //  for which the specified condition evaluates to true. The second list contains those that don't.
    ///
    ///     let (even, odd) = [0, 1, 2, 3, 4, 5].divided { $0 % 2 == 0 }
    ///     let (minors, adults) = people.divided { $0.age < 18 }
   
    func divided(by condition: (Element) throws -> Bool) rethrows -> (matching: [Element], nonMatching: [Element]) {
        var matching = [Element]()
        var nonMatching = [Element]()

        for element in self {
            try condition(element) ? matching.append(element) : nonMatching.append(element)
        }
        return (matching, nonMatching)
    }

    // Return a sorted array based on a key path and a compare function.
    
    func sorted<T>(by keyPath: KeyPath<Element, T>, with compare: (T, T) -> Bool) -> [Element] {
        return sorted { compare($0[keyPath: keyPath], $1[keyPath: keyPath]) }
    }

    // Return a sorted array based on a key path.
   
    func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        return sorted { $0[keyPath: keyPath] < $1[keyPath: keyPath] }
    }

    /// Returns a sorted sequence based on two key paths. The second one will be used in case the values
    /// of the first one match.
    func sorted<T: Comparable, U: Comparable>(
        by keyPath1: KeyPath<Element, T>,
        and keyPath2: KeyPath<Element, U>
    ) -> [Element] {
        return sorted {
            if $0[keyPath: keyPath1] != $1[keyPath: keyPath1] {
                return $0[keyPath: keyPath1] < $1[keyPath: keyPath1]
            }
            return $0[keyPath: keyPath2] < $1[keyPath: keyPath2]
        }
    }

    /// Returns a sorted sequence based on three key paths. Whenever the values of one key path match, the
    /// next one will be used.
    func sorted<T: Comparable, U: Comparable, V: Comparable>(
        by keyPath1: KeyPath<Element, T>,
        and keyPath2: KeyPath<Element, U>,
        and keyPath3: KeyPath<Element, V>
    ) -> [Element] {
        return sorted {
            if $0[keyPath: keyPath1] != $1[keyPath: keyPath1] {
                return $0[keyPath: keyPath1] < $1[keyPath: keyPath1]
            }
            if $0[keyPath: keyPath2] != $1[keyPath: keyPath2] {
                return $0[keyPath: keyPath2] < $1[keyPath: keyPath2]
            }
            return $0[keyPath: keyPath3] < $1[keyPath: keyPath3]
        }
    }

    /// Sum of a `AdditiveArithmetic` property of each `Element` in a `Sequence`.
    ///
    /// ["James", "Wade", "Bryant"].sum(for: \.count) -> 15
   
    func sum<T: AdditiveArithmetic>(for keyPath: KeyPath<Element, T>) -> T {
        return reduce(.zero) { $0 + $1[keyPath: keyPath] }
    }

    /// Returns the first element of the sequence with having property by given key path equals to given
    /// `value`.
   
    func first<T: Equatable>(where keyPath: KeyPath<Element, T>, equals value: T) -> Element? {
        return first { $0[keyPath: keyPath] == value }
    }
}

public extension Sequence where Element: Equatable {
    /// Check if array contains an array of elements.
    ///
    ///        [1, 2, 3, 4, 5].contains([1, 2]) -> true
    ///        [1.2, 2.3, 4.5, 3.4, 4.5].contains([2, 6]) -> false
    ///        ["h", "e", "l", "l", "o"].contains(["l", "o"]) -> true

    func contains(_ elements: [Element]) -> Bool {
        return elements.allSatisfy { contains($0) }
    }
}

extension Sequence where Element: Hashable {
    /// Check if array contains an array of elements.
    ///
    ///        [1, 2, 3, 4, 5].contains([1, 2]) -> true
    ///        [1.2, 2.3, 4.5, 3.4, 4.5].contains([2, 6]) -> false
    ///        ["h", "e", "l", "l", "o"].contains(["l", "o"]) -> true

    func contains(_ elements: [Element]) -> Bool {
        let set = Set(self)
        return elements.allSatisfy { set.contains($0) }
    }

    // Check whether a sequence contains duplicates.
    
    func containsDuplicates() -> Bool {
        var set = Set<Element>()
        return contains { !set.insert($0).inserted }
    }

    // Getting the duplicated elements in a sequence.
    ///
    ///     [1, 1, 2, 2, 3, 3, 3, 4, 5].duplicates().sorted() -> [1, 2, 3])
    ///     ["h", "e", "l", "l", "o"].duplicates().sorted() -> ["l"])
    
    func duplicates() -> [Element] {
        var set = Set<Element>()
        var duplicates = Set<Element>()
        forEach {
            if !set.insert($0).inserted {
                duplicates.insert($0)
            }
        }
        return Array(duplicates)
    }
}

extension Sequence where Element: AdditiveArithmetic {
    // Sum of all elements in array.
    ///
    ///        [1, 2, 3, 4, 5].sum() -> 15
   
    func sum() -> Element {
        return reduce(.zero, +)
    }
}