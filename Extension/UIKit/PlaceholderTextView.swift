import UIKit

final class PlaceholderTextView: UITextView {
	
	var placeholder: String? {
		didSet {
			setNeedsDisplay()
		}
	}
	lazy var placeholderColor: UIColor = textColor ?? .lightText {
		didSet {
			setNeedsDisplay()
		}
	}
	lazy var placeholderFont: UIFont = font ?? .systemFont(ofSize: 14) {
		didSet {
			setNeedsDisplay()
		}
	}
	
	init() {
		super.init(frame: .zero, textContainer: nil)
		setupObservation()
	}
	required init?(coder: NSCoder) {
		nil
	}
	private func setupObservation() {
		NotificationCenter.default.addObserver(self, selector: #selector(textChanged), name: UITextView.textDidChangeNotification, object: nil)
	}
	@objc private func textChanged() {
		setNeedsDisplay()
	}
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
	override func layoutSubviews() {
		super.layoutSubviews()
		setNeedsDisplay()
	}
	override func draw(_ rect: CGRect) {
		guard let validPlaceholder = placeholder as NSString?, text.isEmptyString else {
			return
		}
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.alignment = .left
		let attrs: [NSAttributedString.Key: Any] = [
			.font: placeholderFont,
			.foregroundColor: placeholderColor,
			.paragraphStyle: paragraphStyle
		]
		var textContainerInset = textContainerInset
		if let selectedTextRange = selectedTextRange, selectedTextRange.isEmpty {
			let caret = caretRect(for: selectedTextRange.start)
			// 在光标位置的基础上往右挪一点点
			textContainerInset.left = caret.maxX + 2
		}
		let rect = layer.bounds.inset(by: textContainerInset)
		validPlaceholder.draw(in: rect, withAttributes: attrs)
	}
}
