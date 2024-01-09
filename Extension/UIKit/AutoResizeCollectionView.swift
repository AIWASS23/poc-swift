import UIKit

class AutoResizeCollectionView: UICollectionView {
	override var contentSize: CGSize {
		get { super.contentSize }
		set {
			super.contentSize = newValue
			invalidateIntrinsicContentSize()
		}
	}
	override var intrinsicContentSize: CGSize { contentSize }
}
