import UIKit

/*
Essa extensão fornece funcionalidades adicionais para trabalhar com margens e 
preenchimentos (UIEdgeInsets e NSDirectionalEdgeInsets) de maneira mais conveniente e 
flexível. 
*/

@available(iOS 11.0, *)
extension NSDirectionalEdgeInsets {
	
    var reversed: NSDirectionalEdgeInsets {
        NSDirectionalEdgeInsets(top: -top, leading: -leading, bottom: -bottom, trailing: -trailing)
    }
    
	var uiEdgeInsets: UIEdgeInsets {
		switch UIApplication.shared.userInterfaceLayoutDirection {
			case .leftToRight:
				return UIEdgeInsets(top: top, left: leading, bottom: bottom, right: trailing)
			case .rightToLeft:
				return UIEdgeInsets(top: top, left: trailing, bottom: bottom, right: leading)
			@unknown default:
				return .zero
		}
	}
}

extension UIEdgeInsets {
	
	static func horizontal(_ padding: CGFloat) -> UIEdgeInsets {
		UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
	}
	static func vertical(_ padding: CGFloat) -> UIEdgeInsets {
		UIEdgeInsets(top: padding, left: 0, bottom: padding, right: 0)
	}
	static func top(_ padding: CGFloat) -> UIEdgeInsets {
		UIEdgeInsets(top: padding, left: 0, bottom: 0, right: 0)
	}
	static func left(_ padding: CGFloat) -> UIEdgeInsets {
		UIEdgeInsets(top: 0, left: padding, bottom: 0, right: 0)
	}
	static func bottom(_ padding: CGFloat) -> UIEdgeInsets {
		UIEdgeInsets(top: 0, left: 0, bottom: padding, right: 0)
	}
	static func right(_ padding: CGFloat) -> UIEdgeInsets {
		UIEdgeInsets(top: 0, left: 0, bottom: 0, right: padding)
	}
	
	func offsetBy(x: Double, y: Double) -> UIEdgeInsets {
		UIEdgeInsets(top: top + y, left: left + x, bottom: bottom - y, right: right - x)
	}
	
	func ignoreSafeareaEdges(_ edges: UIRectEdge) -> UIEdgeInsets {
		let screenSafeareaInsets = Size.commonSafeAreaInsets
		var temp = self
		if edges.contains(.top) { temp.top = screenSafeareaInsets.top > 0 ? 0 : top }
		if edges.contains(.left) { temp.left = screenSafeareaInsets.left > 0 ? 0 : left }
		if edges.contains(.bottom) { temp.bottom = screenSafeareaInsets.bottom > 0 ? 0 : bottom }
		if edges.contains(.right) { temp.right = screenSafeareaInsets.right > 0 ? 0 : right }
		return temp
	}
    func topInset(_ inset: CGFloat) -> UIEdgeInsets {
        var insets = self
        insets.top = insets.top + inset
        return insets
    }
	func top(_ padding: CGFloat) -> UIEdgeInsets {
		var insets = self
		insets.top = padding
		return insets
	}
    func leftInset(_ inset: CGFloat) -> UIEdgeInsets {
        var insets = self
        insets.left = insets.left + inset
        return insets
    }
	func left(_ padding: CGFloat) -> UIEdgeInsets {
		var insets = self
		insets.left = padding
		return insets
	}
    func bottomInset(_ inset: CGFloat) -> UIEdgeInsets {
        var insets = self
        insets.bottom = insets.bottom + inset
        return insets
    }
	func bottom(_ padding: CGFloat) -> UIEdgeInsets {
		var insets = self
		insets.bottom = padding
		return insets
	}
    func rightInset(_ inset: CGFloat) -> UIEdgeInsets {
        var insets = self
        insets.right = insets.right + inset
        return insets
    }
	func right(_ padding: CGFloat) -> UIEdgeInsets {
		var insets = self
		insets.right = padding
		return insets
	}
	
    var origin: CGPoint {
        CGPoint(x: left, y: top)
    }
    
	var reversed: UIEdgeInsets {
		UIEdgeInsets(top: -top, left: -left, bottom: -bottom, right: -right)
	}
	
	@available (iOS 11.0, *)
	var directionalEdgeInsets: NSDirectionalEdgeInsets {
		switch UIApplication.shared.userInterfaceLayoutDirection {
			case .leftToRight:
				return NSDirectionalEdgeInsets(top: top, leading: left, bottom: bottom, trailing: right)
			case .rightToLeft:
				return NSDirectionalEdgeInsets(top: top, leading: right, bottom: bottom, trailing: left)
			@unknown default:
				fatalError("UNKNOWN DIRECTION")
		}
	}
}

extension UIEdgeInsets: ExpressibleByFloatLiteral {
	public typealias FloatLiteralType = Double
	public init(floatLiteral literal: Double) {
		self.init(top: literal, left: literal, bottom: literal, right: literal)
	}
}

extension UIEdgeInsets: ExpressibleByIntegerLiteral {
    public typealias IntegerLiteralType = Int
    public init(integerLiteral literal: Int) {
        self.init(floatLiteral: literal.double)
    }
}

extension UIEdgeInsets: ExpressibleByArrayLiteral {
    public typealias ArrayLiteralElement = Double
    public init(arrayLiteral literal: Double...) {
        guard literal.count == 4 else {
            fatalError("No enough element to build a NSDirectionalEdgeInsets")
        }
        self.init(top: literal[0], left: literal[1], bottom: literal[2], right: literal[3])
    }
}

extension NSDirectionalEdgeInsets: ExpressibleByFloatLiteral {
	public typealias FloatLiteralType = Double
	public init(floatLiteral literal: Double) {
		self.init(top: literal, leading: literal, bottom: literal, trailing: literal)
	}
}

extension NSDirectionalEdgeInsets: ExpressibleByIntegerLiteral {
    public typealias IntegerLiteralType = Int
    public init(integerLiteral literal: Int) {
        self.init(floatLiteral: literal.double)
    }
}

extension NSDirectionalEdgeInsets: ExpressibleByArrayLiteral {
    public typealias ArrayLiteralElement = Double
    public init(arrayLiteral literal: Double...) {
        guard literal.count == 4 else {
            fatalError("No enough element to build a NSDirectionalEdgeInsets")
        }
        self.init(top: literal[0], leading: literal[1], bottom: literal[2], trailing: literal[3])
    }
}

extension UIEdgeInsets {
    
    static func +(lhs: UIEdgeInsets, rhs: Double) -> UIEdgeInsets {
        UIEdgeInsets(
            top: lhs.top + rhs,
            left: lhs.left + rhs,
            bottom: lhs.bottom + rhs,
            right: lhs.right + rhs
        )
    }
    
    static func +(lhs: UIEdgeInsets, rhs: UIEdgeInsets) -> UIEdgeInsets {
        UIEdgeInsets(
            top: lhs.top + rhs.top,
            left: lhs.left + rhs.left,
            bottom: lhs.bottom + rhs.bottom,
            right: lhs.right + rhs.right
        )
    }
}
