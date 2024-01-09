import UIKit

final class AutoResizeTextView: UITextView {

	var maxHeight = CGFloat.greatestFiniteMagnitude
	
	override var contentSize: CGSize {
		get { super.contentSize }
		set {
			invalidateIntrinsicContentSize()
			super.contentSize = newValue
		}
	}
	
	override var intrinsicContentSize: CGSize {
		let targetSize = contentSize + contentInset
		guard targetSize.height <= maxHeight else {
			var maxSize = contentSize
			maxSize.height = maxHeight
			return maxSize
		}
		return targetSize
	}
}
