
import Foundation

extension Array where Element: Equatable{
    
    mutating func update(with element:Element) {
        var n = 0
        for item in self {
            if item == element {
                remove(at: n)
                insert(element, at: n)
                return
            }
            n += 1
        }
        append(element)
    }

    mutating func update(with elements:[Element]) {
        
        guard count > 0 else {
            append(contentsOf: elements)
            return
        }
        
        for element in elements {
            update(with: element)
        }
    }
}
