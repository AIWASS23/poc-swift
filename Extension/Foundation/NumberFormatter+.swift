import Foundation

extension NumberFormatter {
	func string(from decimal: Decimal) -> String? {
		string(from: decimal as NSDecimalNumber)
	}
	
	static func percent(
		position context: Formatter.Context,
		for locale: Locale
	) -> NumberFormatter {
		let formatter = NumberFormatter()
		formatter.numberStyle = .percent
		formatter.locale = locale
		formatter.formattingContext = context
		formatter.maximumFractionDigits = 2
		return formatter
	}
	
	static func decimal(
		position context: Formatter.Context,
		for locale: Locale
	) -> NumberFormatter {
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		formatter.locale = locale
		formatter.formattingContext = context
		return formatter
	}
	
	/// - Parameter code: ISO 4217 code
	static func currency(
		_ code: String,
		position context: Formatter.Context,
		for locale: Locale,
		alwaysShowFraction: Bool
	) -> NumberFormatter {
		let formatter = NumberFormatter()
		formatter.numberStyle = .currency
		formatter.currencyCode = code
		formatter.locale = locale
		if not(alwaysShowFraction) {
			formatter.minimumFractionDigits = 0
		}
		formatter.formattingContext = context
		return formatter
	}
}
