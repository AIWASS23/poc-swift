import UIKit

final class UIBackgroundExpendedButton: UIButton {

	lazy var backgroundImageInsets: UIEdgeInsets = contentEdgeInsets {
		didSet {
			invalidateIntrinsicContentSize()
		}
	}
	
	override func backgroundRect(forBounds bounds: CGRect) -> CGRect {
		backgroundImageView?.contentMode = .center
		return bounds.inset(by: backgroundImageInsets)
	}
	
	override var intrinsicContentSize: CGSize {
		guard let backgroundImage = backgroundImage(for: state) else {
			return super.intrinsicContentSize
		}
		return backgroundImage.size + backgroundImageInsets
	}

}
