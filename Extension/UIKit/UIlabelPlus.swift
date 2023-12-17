import UIKit

extension UILabel {
	
	convenience init(
		text: String? = nil,
		textColor: UIColor? = nil,
		fontSize: Double = 12.0,
		fontWeight: UIFont.Weight = .regular,
        alignment: NSTextAlignment = .left) {
			let font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
			self.init(text: text, textColor: textColor, font: font)
            textAlignment = alignment
		}
	
	convenience init(
		text: String?,
		textColor: UIColor? = nil,
		font: UIFont = .systemFont(ofSize: 12, weight: .regular)) {
			self.init(frame: .zero)
			self.text = text
			self.textColor = textColor ?? .darkText
			self.font = font
		}
}
