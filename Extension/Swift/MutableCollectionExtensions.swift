import Foundation
extension MutableCollection where Self: RandomAccessCollection {
    // Sort the collection based on a keypath and a compare function.
    
    mutating func sort<T>(by keyPath: KeyPath<Element, T>, with compare: (T, T) -> Bool) {
        sort { compare($0[keyPath: keyPath], $1[keyPath: keyPath]) }
    }

    // Sort the collection based on a keypath.
    
    mutating func sort<T: Comparable>(by keyPath: KeyPath<Element, T>) {
        sort { $0[keyPath: keyPath] < $1[keyPath: keyPath] }
    }

    // Sort the collection based on two key paths. The second one will be used in case the values of the
    // first one match.
    mutating func sort<T: Comparable, U: Comparable>(
        by keyPath1: KeyPath<Element, T>,
        and keyPath2: KeyPath<Element, U>
    ) {
        sort {
            if $0[keyPath: keyPath1] != $1[keyPath: keyPath1] {
                return $0[keyPath: keyPath1] < $1[keyPath: keyPath1]
            }
            return $0[keyPath: keyPath2] < $1[keyPath: keyPath2]
        }
    }

    // Sort the collection based on three key paths. Whenever the values of one key path match, the next
    // one will be used.
    mutating func sort<T: Comparable, U: Comparable, V: Comparable>(
        by keyPath1: KeyPath<Element, T>,
        and keyPath2: KeyPath<Element, U>,
        and keyPath3: KeyPath<Element, V>
    ) {
        sort {
            if $0[keyPath: keyPath1] != $1[keyPath: keyPath1] {
                return $0[keyPath: keyPath1] < $1[keyPath: keyPath1]
            }
            if $0[keyPath: keyPath2] != $1[keyPath: keyPath2] {
                return $0[keyPath: keyPath2] < $1[keyPath: keyPath2]
            }
            return $0[keyPath: keyPath3] < $1[keyPath: keyPath3]
        }
    }
}

extension MutableCollection {
    // Assign a given value to a field `keyPath` of all elements in the collection.
    
    mutating func assignToAll<Value>(
        value: Value, 
        by keyPath: WritableKeyPath<Element, Value>
    ) {
        for idx in indices {
            self[idx][keyPath: keyPath] = value
        }
    }
}
