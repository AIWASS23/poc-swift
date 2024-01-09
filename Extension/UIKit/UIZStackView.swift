import UIKit

class UIZStackView: UIStackView {
	
	var zAlignment: Alignment = .center
	
	private var largestSubView: UIView?
	
	override var intrinsicContentSize: CGSize {
		largestSubView?.frame.size ?? super.intrinsicContentSize
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		zLayoutSubviews()
	}
	
	private func zLayoutSubviews() {
		
		
		let soredSubviews = arrangedSubviews.sorted { lhs, rhs in
			lhs.frame.size <= rhs.frame.size
		}
		
		largestSubView = soredSubviews.last
		
		soredSubviews.forEach { subview in
			switch zAlignment {
			case .center:
				subview.center = self.center
			case .leading:
				subview.center = self.center
				switch UIApplication.shared.userInterfaceLayoutDirection {
				case .leftToRight:
					subview.frame.origin.x = 0
				case .rightToLeft:
					subview.frame.origin.x = largestSubView.unwrap(\.frame.size.width, or: bounds.size.width) - subview.frame.size.width
				@unknown default:
					break
				}
			case .trailing:
				subview.center = self.center
				switch UIApplication.shared.userInterfaceLayoutDirection {
				case .leftToRight:
					subview.frame.origin.x = largestSubView.unwrap(\.frame.size.width, or: bounds.size.width) - subview.frame.size.width
				case .rightToLeft:
					subview.frame.origin.x = 0
				@unknown default:
					break
				}
			case .top:
				subview.center = self.center
				subview.frame.origin.y = 0
			case .bottom:
				subview.center = self.center
				subview.frame.origin.y = 0
			case .topLeading:
				subview.center = self.center
				subview.frame.origin.y = 0
				switch UIApplication.shared.userInterfaceLayoutDirection {
				case .leftToRight:
					subview.frame.origin.x = 0
				case .rightToLeft:
					subview.frame.origin.x = largestSubView.unwrap(\.frame.size.width, or: bounds.size.width) - subview.frame.size.width
				@unknown default:
					break
				}
			case .topTrailing:
				subview.center = self.center
				subview.frame.origin.y = 0
				switch UIApplication.shared.userInterfaceLayoutDirection {
				case .leftToRight:
					subview.frame.origin.x = largestSubView.unwrap(\.frame.size.width, or: bounds.size.width) - subview.frame.size.width
				case .rightToLeft:
					subview.frame.origin.x = 0
				@unknown default:
					break
				}
			case .bottomLeading:
				subview.center = self.center
				subview.frame.origin.y = largestSubView.unwrap(\.frame.size.height, or: bounds.size.height) - subview.frame.size.height
				switch UIApplication.shared.userInterfaceLayoutDirection {
				case .leftToRight:
					subview.frame.origin.x = 0
				case .rightToLeft:
					subview.frame.origin.x = largestSubView.unwrap(\.frame.size.width, or: bounds.size.width) - subview.frame.size.width
				@unknown default:
					break
				}
			case .bottomTrailing:
				subview.center = self.center
				subview.frame.origin.y = largestSubView.unwrap(\.frame.size.height, or: bounds.size.height) - subview.frame.size.height
				switch UIApplication.shared.userInterfaceLayoutDirection {
				case .leftToRight:
					subview.frame.origin.x = largestSubView.unwrap(\.frame.size.width, or: bounds.size.width) - subview.frame.size.width
				case .rightToLeft:
					subview.frame.origin.x = 0
				@unknown default:
					break
				}
			}
		}
		
		if let _ = largestSubView {
			invalidateIntrinsicContentSize()
		}
	}
}

extension UIZStackView {
	enum Alignment {
		case center
		case leading
		case trailing
		case top
		case bottom
		case topLeading
		case topTrailing
		case bottomLeading
		case bottomTrailing
	}
}
