import UIKit

extension String.StringInterpolation {
	
	mutating func appendInterpolation(age years: Int) {
		let formatter = NumberFormatter.shared.configure { make in
			make.numberStyle = .spellOut
		}
		let result = formatter.string(from: years as NSNumber) ?? ""
		appendLiteral(result)
	}
	
	mutating func appendInterpolation(height meters: Int) {
		appendLiteral("\(meters) meters tall")
	}
	
	mutating func appendInterpolation(_ strings: [String], ifEmpty defaultValue: @autoclosure () -> String) {
		if strings.isEmpty {
			appendLiteral(defaultValue())
		} else {
			appendLiteral(strings.joined(separator: ", "))
		}
	}
	
	mutating func appendInterpolation<T: Encodable>(debug value: T) throws {
		let encoder = JSONEncoder()
		encoder.outputFormatting = .prettyPrinted
		
		let result = try encoder.encode(value)
		let string = String(decoding: result, as: UTF8.self)
		appendLiteral(string)
	}
}

struct ColoredString: ExpressibleByStringInterpolation {
	
	struct StringInterpolation: StringInterpolationProtocol {
		var output = NSMutableAttributedString()
		var baseAttributes: [NSAttributedString.Key: Any] = [
			.font: UIFont(name: "Georgia-Italic", size: 64) ?? .systemFont(ofSize: 64),
			.foregroundColor: UIColor.black
		]
		
		init(literalCapacity: Int, interpolationCount: Int) { }
		
		mutating func appendLiteral(_ literal: String) {
			let attributedString = NSAttributedString(string: literal, attributes: baseAttributes)
			output.append(attributedString)
		}
		
		mutating func appendInterpolation(message: String, color: UIColor = .black) {
			var coloredAttributes = baseAttributes
			coloredAttributes[.foregroundColor] = color
			
			let attributedString = NSAttributedString(string: message, attributes: coloredAttributes)
			output.append(attributedString)
		}
	}
	
	let value: NSAttributedString
	init(stringLiteral value: String) {
		self.value = NSAttributedString(string: value)
	}
	init(stringInterpolation: StringInterpolation) {
		self.value = stringInterpolation.output
	}
}
