import Foundation

/*
Essa funcionalidade pode ser útil em situações onde você precisa criar arrays com elementos repetidos
*/

extension Array {
    init(repeating: [Element], count: Int) {
        self.init([[Element]](repeating: repeating, count: count).flatMap{$0})
    }
    func repeated(count: Int) -> [Element] {
        return [Element](repeating: self, count: count)
    }
}
