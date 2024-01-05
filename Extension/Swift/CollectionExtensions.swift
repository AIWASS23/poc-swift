import Foundation

extension Collection {
    // The full range of the collection.
    var fullRange: Range<Index> { startIndex..<endIndex }
}

extension Collection {
    #if canImport(Dispatch)
    // Performs `each` closure for each element of collection in parallel.
    ///
    ///        array.forEachInParallel { item in
    ///            print(item)
    ///        }
    ///
    func forEachInParallel(_ each: (Self.Element) -> Void) {
        DispatchQueue.concurrentPerform(iterations: count) {
            each(self[index(startIndex, offsetBy: $0)])
        }
    }
    #endif

    // Safe protects the array from out of bounds by use of optional.
    ///
    ///        let arr = [1, 2, 3, 4, 5]
    ///        arr[safe: 1] -> 2
    ///        arr[safe: 10] -> nil
    ///
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }

    // Returns an array of slices of length "size" from the array. If array can't be split evenly, the
    // final slice will be the remaining elements.
    ///
    ///     [0, 2, 4, 7].group(by: 2) -> [[0, 2], [4, 7]]
    ///     [0, 2, 4, 7, 6].group(by: 2) -> [[0, 2], [4, 7], [6]]
    ///
    
    func group(by size: Int) -> [[Element]]? {
        guard size > 0, !isEmpty else { return nil }
        var start = startIndex
        var slices = [[Element]]()
        while start != endIndex {
            let end = index(start, offsetBy: size, limitedBy: endIndex) ?? endIndex
            slices.append(Array(self[start..<end]))
            start = end
        }
        return slices
    }

    // Get all indices where condition is met.
    ///
    ///     [1, 7, 1, 2, 4, 1, 8].indices(where: { $0 == 1 }) -> [0, 2, 5]
    ///

    func indices(where condition: (Element) throws -> Bool) rethrows -> [Index]? {
        let indices = try self.indices.filter { try condition(self[$0]) }
        return indices.isEmpty ? nil : indices
    }

    // Calls the given closure with an array of size of the parameter slice.
    ///
    ///     [0, 2, 4, 7].forEach(slice: 2) { print($0) } -> // print: [0, 2], [4, 7]
    ///     [0, 2, 4, 7, 6].forEach(slice: 2) { print($0) } -> // print: [0, 2], [4, 7], [6]
    ///
    
    func forEach(slice: Int, body: ([Element]) throws -> Void) rethrows {
        var start = startIndex
        while case let end = index(start, offsetBy: slice, limitedBy: endIndex) ?? endIndex,
              start != end {
            try body(Array(self[start..<end]))
            start = end
        }
    }

    // Unique pair of elements in a collection.
    ///
    ///        let array = [1, 2, 3]
    ///        for (first, second) in array.adjacentPairs() {
    ///            print(first, second) // print: (1, 2) (1, 3) (2, 3)
    ///        }
   
    func adjacentPairs() -> AnySequence<(Element, Element)> {
        guard var index1 = index(startIndex, offsetBy: 0, limitedBy: endIndex),
              var index2 = index(index1, offsetBy: 1, limitedBy: endIndex) else {
            return AnySequence {
                EmptyCollection.Iterator()
            }
        }
        return AnySequence {
            AnyIterator {
                if index1 >= endIndex || index2 >= endIndex {
                    return nil
                }
                defer {
                    index2 = self.index(after: index2)
                    if index2 >= endIndex {
                        index1 = self.index(after: index1)
                        index2 = self.index(after: index1)
                    }
                }
                return (self[index1], self[index2])
            }
        }
    }
}

extension Collection where Element: Equatable {
    // All indices of specified item.
    ///
    ///        [1, 2, 2, 3, 4, 2, 5].indices(of 2) -> [1, 2, 5]
    ///        [1.2, 2.3, 4.5, 3.4, 4.5].indices(of 2.3) -> [1]
    ///        ["h", "e", "l", "l", "o"].indices(of "l") -> [2, 3]
   
    func indices(of item: Element) -> [Index] {
        return indices.filter { self[$0] == item }
    }
}


extension Collection where Element: BinaryInteger {
    // Average of all elements in array.
    
    func average() -> Double {
        guard !isEmpty else { return .zero }
        return Double(reduce(.zero, +)) / Double(count)
    }
}


extension Collection where Element: FloatingPoint {
    // Average of all elements in array.
    
    func average() -> Element {
        guard !isEmpty else { return .zero }
        return reduce(.zero, +) / Element(count)
    }
}
