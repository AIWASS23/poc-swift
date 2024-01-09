import UIKit

final class Spacer: UIView {
	private let width: CGFloat?
	private let height: CGFloat?
    
    override init(frame: CGRect) {
        width = nil
        height = nil
        super.init(frame: frame)
    }
    
	init(width: CGFloat? = nil, height: CGFloat? = nil) {
		self.width = width
		self.height = height
		let size = CGSize(width: width ?? 0, height: height ?? 0)
		let rect = CGRect(origin: .zero, size: size)
		super.init(frame: rect)
	}
    
	required init?(coder: NSCoder) { nil }
    
	override var intrinsicContentSize: CGSize {
		var size = UIView.layoutFittingExpandedSize
		if let width = width {
			size.width = width
		}
		if let height = height {
			size.height = height
		}
		return size
	}
}
