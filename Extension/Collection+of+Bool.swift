import Foundation

extension Collection<Bool> {
	@inlinable
	func and() -> Bool {
		reduce(true) { partialResult, element in
			partialResult && element
		}
	}
	
	@inlinable
	func or() -> Bool {
		reduce(false) { partialResult, element in
			partialResult || element
		}
	}
}
