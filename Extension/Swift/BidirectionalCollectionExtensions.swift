import Foundation

extension BidirectionalCollection {
    // Returns the element at the specified position. If offset is negative, the `n`th element from the
    // end will be returned where `n` is the result of `abs(distance)`.
   
    subscript(offset distance: Int) -> Element {
        let index = distance >= 0 ? startIndex : endIndex
        return self[indices.index(index, offsetBy: distance)]
    }

    // Returns the last element of the sequence with having property by given key path equals to given
    
    func last<T: Equatable>(where keyPath: KeyPath<Element, T>, equals value: T) -> Element? {
        return last { $0[keyPath: keyPath] == value }
    }
}
