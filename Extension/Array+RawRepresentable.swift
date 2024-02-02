import Foundation

extension Array: RawRepresentable where Element: RawRepresentable, Element.RawValue == String {
	init?(rawValue: String) {
		self = rawValue
			.deleting(prefix: .leftBracket)
			.deleting(suffix: .rightBracket)
			.split(separator: .comaChar)
			.map(\.withSpacesTrimmed)
			.compactMap(Element.init(rawValue:))
	}
	
	@inlinable
	var rawValue: String {
		self.map(\.rawValue)
			.joined(separator: .coma)
	}
}