import Foundation

extension Collection {
	subscript (cycle index: Index) -> Element {
		self[self.index(startIndex, offsetBy: distance(from: startIndex, to: index) % count)]
	}
}

extension Collection where Index == Int {
	subscript (cycle index: Index) -> Element {
		self[index % count]
	}
}
