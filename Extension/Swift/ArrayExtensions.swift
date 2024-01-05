import Foundation

extension Array {
    // Creates an array with specified number of elements, for each element it calls specified closure.

    init(count: Int, element: (Int) throws -> Element) rethrows {
        try self.init(unsafeUninitializedCapacity: count) { buffer, initializedCount in
            for index in 0..<count {
                try buffer.baseAddress?.advanced(by: index).initialize(to: element(index))
            }
            initializedCount = count
        }
    }
}

extension Array {
    // Insert an element at the beginning of array.

    mutating func prepend(_ newElement: Element) {
        insert(newElement, at: 0)
    }

    // Safely swap values at given index positions.
    
    mutating func safeSwap(from index: Index, to otherIndex: Index) {
        guard index != otherIndex else { return }
        guard startIndex..<endIndex ~= index else { return }
        guard startIndex..<endIndex ~= otherIndex else { return }
        swapAt(index, otherIndex)
    }

    // Sort an array like another array based on a key path. If the other array doesn't contain a certain value, it will be sorted last.
    
    func sorted<T: Hashable>(like otherArray: [T], keyPath: KeyPath<Element, T>) -> [Element] {
        let dict = otherArray.enumerated().reduce(into: [:]) { $0[$1.element] = $1.offset }
        return sorted {
            guard let thisIndex = dict[$0[keyPath: keyPath]] else { return false }
            guard let otherIndex = dict[$1[keyPath: keyPath]] else { return true }
            return thisIndex < otherIndex
        }
    }
}

extension Array where Element: Equatable {
    // Remove all instances of an item from array.
    
    @discardableResult
    mutating func removeAll(_ item: Element) -> [Element] {
        removeAll(where: { $0 == item })
        return self
    }

    // Remove all instances contained in items parameter from array.
    
    @discardableResult
    mutating func removeAll(_ items: [Element]) -> [Element] {
        guard !items.isEmpty else { return self }
        removeAll(where: { items.contains($0) })
        return self
    }

    // Remove all duplicate elements from Array.
   
    @discardableResult
    mutating func removeDuplicates() -> [Element] {
        self = reduce(into: [Element]()) {
            if !$0.contains($1) {
                $0.append($1)
            }
        }
        return self
    }

    // Return array with all duplicate elements removed.
   
    func withoutDuplicates() -> [Element] {
        return reduce(into: [Element]()) {
            if !$0.contains($1) {
                $0.append($1)
            }
        }
    }

    // Returns an array with all duplicate elements removed using KeyPath to compare.
    
    func withoutDuplicates<E: Equatable>(keyPath path: KeyPath<Element, E>) -> [Element] {
        return reduce(into: [Element]()) { result, element in
            if !result.contains(where: { $0[keyPath: path] == element[keyPath: path] }) {
                result.append(element)
            }
        }
    }

    // Returns an array with all duplicate elements removed using KeyPath to compare.
    
    func withoutDuplicates<E: Hashable>(keyPath path: KeyPath<Element, E>) -> [Element] {
        var set = Set<E>()
        return filter { set.insert($0[keyPath: path]).inserted }
    }
}
