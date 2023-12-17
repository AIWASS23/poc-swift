import UIKit

class InsetsLabel: UILabel {
	
	var textEdgeInsets: UIEdgeInsets = .zero {
		didSet {
			setNeedsDisplay()
			invalidateIntrinsicContentSize()
		}
	}
	
	var roundCornersOption: (UIRectCorner, CGFloat)?
	
	override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
		super.textRect(forBounds: bounds.inset(by: textEdgeInsets), limitedToNumberOfLines: numberOfLines)
			.inset(by: textEdgeInsets.reversed)
	}
	
	override var preferredMaxLayoutWidth: CGFloat {
		get { super.preferredMaxLayoutWidth }
		set { super.preferredMaxLayoutWidth = newValue }
	}
	
	override func drawText(in rect: CGRect) {
		if let option = roundCornersOption {
			roundCorners(corners: option.0, cornerRadius: option.1)
		}
		super.drawText(in: rect.inset(by: textEdgeInsets))
	}
}

extension InsetsLabel {
    
    func padding(_ insets: UIEdgeInsets) -> Self {
        textEdgeInsets = insets
        return self
    }
}
