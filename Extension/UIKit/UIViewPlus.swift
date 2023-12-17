import UIKit
import SwiftUI

protocol Tapable {
    associatedtype T = Self
    func addTappedExecution(_ execute: ((T) -> Void)?)
}

extension UIView: Tapable {
    fileprivate static var targetsArrayKey = UUID()
    fileprivate static var tappedClosureKey = UUID()
    fileprivate var targets: NSMutableArray {
        if let array = getAssociatedObject(self, &Self.targetsArrayKey) as? NSMutableArray {
            return array
        } else {
            let array = NSMutableArray()
            setAssociatedObject(self, &Self.targetsArrayKey, array, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return array
        }
    }
}

extension Tapable where Self: UIView {
    
    var tapped: ((Self) -> Void)? {
        get {
            if let target = getAssociatedObject(self, &Self.tappedClosureKey) as? ClosureSleeve<Self> {
                return target.actionCallback
            } else {
                return nil
            }
        }
        set {
            isUserInteractionEnabled = true
            if let target = getAssociatedObject(self, &Self.tappedClosureKey) as? ClosureSleeve<Self> {
                target.actionCallback = newValue
            } else {
                let target = ClosureSleeve(sender: self, newValue)
                let tapGesture = UITapGestureRecognizer(target: target, action: #selector(target.action))
                addGestureRecognizer(tapGesture)
                setAssociatedObject(self, &Self.tappedClosureKey, target, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    func addTappedExecution(_ execute: ((Self) -> Void)?) {
        let target = ClosureSleeve(sender: self, execute)
        let tapGesture = UITapGestureRecognizer(target: target, action: #selector(target.action))
        addGestureRecognizer(tapGesture)
        targets.add(target)
    }
}

extension UIView {
	
	convenience init(color: UIColor?) {
		self.init(frame: .zero)
		backgroundColor = color
	}
	
	static func cornerRadius(_ cornerRadius: CGFloat, color: UIColor = .white) -> UIView {
		UIView.make { make in
			make.backgroundColor = color
			make.layer.cornerRadius = cornerRadius
		}
	}
}

extension UIView {
	
    enum Associated {
        static var shadowViewKey = UUID()
        static var backgroundViewKey = UUID()
        static var mournFilterViewKey = UUID()
    }
    
    var naturalSize: CGSize {
        systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
    
    var isPortrait: Bool {
        frame.size.isPortrait
    }
    
    var isLandscape: Bool {
        frame.size.isLandscape
    }
    
    var globalPoint :CGPoint? {
        superview?.convert(frame.origin, to: nil)
    }

    var globalFrame :CGRect? {
        superview?.convert(frame, to: nil)
    }
    
    var mournView: UIView? {
        get {
            getAssociatedObject(self, &Associated.mournFilterViewKey) as? UIView
        }
        set {
            setAssociatedObject(self, &Associated.mournFilterViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public func addShadow(offset: CGSize = .zero, opacity: Float = 0.65, radius: CGFloat = 20, color: UIColor = .black) {
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowColor = color.cgColor
        layer.masksToBounds = false
    }
    
    
    public func rotate(_ degree: Int) {
        let angle = (CGFloat.pi / 180.0) * degree.cgFloat
        transform = CGAffineTransform(rotationAngle: angle)
    }
    
    public func preferredSize(maxSize: CGSize? = nil, stretchAxis: NSLayoutConstraint.Axis = .vertical) -> CGSize {
        var systemLayoutSize = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        if let maxSize {
            switch stretchAxis {
            case .horizontal:
                if systemLayoutSize.height > maxSize.height {
                    systemLayoutSize = systemLayoutSizeFitting(maxSize, withHorizontalFittingPriority: .fittingSizeLevel, verticalFittingPriority: .required)
                }
            case .vertical:
                if systemLayoutSize.width > maxSize.width {
                    systemLayoutSize = systemLayoutSizeFitting(maxSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
                }
            @unknown default:
                break
            }
        }
        return systemLayoutSize
    }
    
    @available(iOS 12.0, *)
    public func mourn(_ mourn: Bool = true) {
        if let mournView {
            if mourn {
                mournView.frame = bounds
            } else {
                mournView.removeFromSuperview()
                self.mournView = nil
            }
        } else if mourn {
            let mournFilter = UIView(frame: bounds)
            mournFilter.isUserInteractionEnabled = false
            mournFilter.backgroundColor = .lightGray
            mournFilter.layer.compositingFilter = "saturationBlendMode"
            mournFilter.layer.zPosition = .greatestFiniteMagnitude
            addSubview(mournFilter)
            self.mournView = mournFilter
        }
    }
    
    func relativeFrameTo(_ target: UIView) -> CGRect? {
        superview?.convert(frame, to: target)
    }
    
    func tagged(_ tag: Int) -> Self {
        self.tag = tag
        return self
    }
    
    
    func add(backgroundColor: UIColor) {
        let background = UIView(frame: bounds)
        background.backgroundColor = backgroundColor
        add(backgroundView: background)
    }
    
    func add(cornerRadius: CGFloat, insets: UIEdgeInsets = .zero, maskedCorners: CACornerMask = .allCorners, backgroundColor: UIColor, borderWidth: CGFloat? = nil, borderColor: UIColor? = nil) {
        let bgView = UIView(color: backgroundColor)
        bgView.layer.maskedCorners = maskedCorners
        bgView.layer.cornerRadius = cornerRadius
        if let borderWidth, borderWidth > 0 {
            bgView.layer.borderWidth = borderWidth
            bgView.layer.borderColor = borderColor?.cgColor
        }
        add(backgroundView: bgView, insets: insets)
    }
    
    func add(overlay: UIView) {
        add(backgroundView: overlay)
        bringSubviewToFront(overlay)
    }

    func add(backgroundView: UIView, insets: UIEdgeInsets = .zero, configure: ((UIView) -> Void)? = nil) {
        let frame = bounds.inset(by: insets)
        if let configure {
            configure(backgroundView)
        }
        add(backgroundView: backgroundView, frame: frame)
    }
    
    func add(backgroundView: UIView, frame: CGRect) {
        backgroundView.frame = frame
        backgroundView.autoresizingMask = .autoResize
        insertSubview(backgroundView, at: 0)
        kk.backgroundView = backgroundView
    }
    
	func snapshotScreen(scrollView: UIScrollView) -> UIImage?{
		if UIScreen.main.responds(to: #selector(getter: UIScreen.scale)) {
			UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, false, UIScreen.main.scale)
		} else {
			UIGraphicsBeginImageContext(scrollView.contentSize)
		}
		
		let savedContentOffset = scrollView.contentOffset
		let savedFrame = scrollView.frame
		let contentSize = scrollView.contentSize
		let oldBounds = scrollView.layer.bounds
		
		if #available(iOS 13, *) {
			scrollView.layer.bounds = CGRect(x: oldBounds.origin.x, y: oldBounds.origin.y, width: contentSize.width, height: contentSize.height)
		}
		scrollView.contentOffset = CGPoint.zero
		scrollView.frame = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height)
		
		if let context = UIGraphicsGetCurrentContext() {
			scrollView.layer.render(in: context)
		}
		if #available(iOS 13, *) {
			scrollView.layer.bounds = oldBounds
		}
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		scrollView.contentOffset = savedContentOffset
		scrollView.frame = savedFrame
		return image
	}
	
	private func getTableViewScreenshot(tableView: UITableView,whereView: UIView) -> UIImage?{
		let scrollView = UIScrollView()
		scrollView.backgroundColor = UIColor.white
		scrollView.frame = whereView.bounds
		scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: tableView.contentSize.height)
		scrollView.addSubview(tableView)
		let constraints = [
			tableView.topAnchor.constraint(equalTo: scrollView.topAnchor),
			tableView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
			tableView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
			tableView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
			tableView.heightAnchor.constraint(equalToConstant: tableView.contentSize.height)
		]
		NSLayoutConstraint.activate(constraints)
		whereView.addSubview(scrollView)
		let image = snapshotScreen(scrollView: scrollView)
		scrollView.removeFromSuperview()
		return image
	}

	var snapshot: UIImage? {
		switch self {
			case let unwrapped where unwrapped is UITableView:
				let tableView = unwrapped as! UITableView
				return getTableViewScreenshot(tableView: tableView, whereView: superview!)
			default:
				UIGraphicsBeginImageContextWithOptions(frame.size, true, UIScreen.main.scale)
				layer.render(in: UIGraphicsGetCurrentContext()!)
				let image = UIGraphicsGetImageFromCurrentImageContext()

				UIGraphicsEndImageContext()
				return image
		}
	}
    
    @available(iOS 11.0, *)
    var additionalSafeAreaInsetsFromSuperView: UIEdgeInsets {
        .bottom(bottomSafeAreaPadding + frame.height)
    }
    
    @available(iOS 11.0, *)
    var bottomSafeAreaPadding: Double {
        guard let superview else { return 0 }
        return superview.bounds.height - frame.maxY - superview.safeAreaInsets.bottom
    }
}

extension Array where Element: UIView {

	func embedInStackView(
		axis: NSLayoutConstraint.Axis = .vertical,
		distribution: UIStackView.Distribution = .fill,
		alignment: UIStackView.Alignment = .leading,
		spacing: CGFloat = 0)
	-> UIStackView {
		let stackView = UIStackView(arrangedSubviews: self)
		stackView.axis = axis
		stackView.distribution = distribution
		stackView.alignment = alignment
		stackView.spacing = spacing
		return stackView
	}
}
extension UIView {
    
    @discardableResult func fix(proportion: CGSize?, priority: UILayoutPriority = .required) -> Self {
        
        let existedConstraints = constraints.filter { constraint in
            guard constraint.relation == .equal else { return false }
            guard constraint.firstAttribute == .width else { return false }
            guard constraint.secondAttribute == .height else { return false }
            return true
        }
        NSLayoutConstraint.deactivate(existedConstraints)
        
        if let proportion {
            translatesAutoresizingMaskIntoConstraints = false
            let multiplier = proportion.width / proportion.height
            let constraint = widthAnchor.constraint(equalTo: heightAnchor, multiplier: multiplier)
            constraint.priority = priority
            constraint.isActive = true
        }
        return self
    }
    
    @discardableResult func fix(size: CGSize) -> Self {
        fix(width: size.width, height: size.height)
    }
    
    @discardableResult func fix(width: CGFloat? = nil, height: CGFloat? = nil) -> Self {
        fix(width: width?.constraint, height: height?.constraint)
    }
    
    @discardableResult func fix(width: UILayoutConstraint? = nil, height: UILayoutConstraint? = nil) -> Self {
        
        func deactivateWidthConstraintsIfNeeded() {
            let existedConstraints = constraints.filter { constraint in
                guard constraint.relation == .equal else { return false }
                guard constraint.firstAttribute == .width else { return false }
                guard constraint.secondAttribute == .notAnAttribute else { return false }
                return true
            }
            if existedConstraints.isEmpty { return }
            NSLayoutConstraint.deactivate(existedConstraints)
        }
        
        func deactivateHeightConstraintsIfNeeded() {
            let existedConstraints = constraints.filter { constraint in
                guard constraint.relation == .equal else { return false }
                guard constraint.firstAttribute == .height else { return false }
                guard constraint.secondAttribute == .notAnAttribute else { return false }
                return true
            }
            if existedConstraints.isEmpty { return }
            NSLayoutConstraint.deactivate(existedConstraints)
        }
        
        guard width.isValid || height.isValid else {
            deactivateWidthConstraintsIfNeeded()
            deactivateHeightConstraintsIfNeeded()
            return self
        }

        translatesAutoresizingMaskIntoConstraints = false

        if let width {
            deactivateWidthConstraintsIfNeeded()
            let constraint = widthAnchor.constraint(equalToConstant: width.constant)
            constraint.priority = width.priority
            constraint.isActive = true
        }

        if let height {
            deactivateHeightConstraintsIfNeeded()
            let constraint = heightAnchor.constraint(equalToConstant: height.constant)
            constraint.priority = height.priority
            constraint.isActive = true
        }
        return self
    }
    
    @discardableResult func limit(widthRange: ClosedRange<CGFloat>? = nil, heightRange: ClosedRange<CGFloat>? = nil) -> Self {
        limit(minWidth: widthRange?.lowerBound,
              maxWidth: widthRange?.upperBound,
              minHeight: heightRange?.lowerBound,
              maxHeight: heightRange?.upperBound)
    }
    
    @discardableResult func limit(minWidth: CGFloat? = nil, maxWidth: CGFloat? = nil, minHeight: CGFloat? = nil, maxHeight: CGFloat? = nil) -> Self {
        limit(minWidth: minWidth?.constraint,
              maxWidth: maxWidth?.constraint,
              minHeight: minHeight?.constraint,
              maxHeight: maxHeight?.constraint)
    }
    
    @discardableResult func limit(minWidth: UILayoutConstraint? = nil, maxWidth: UILayoutConstraint? = nil, minHeight: UILayoutConstraint? = nil, maxHeight: UILayoutConstraint? = nil) -> Self {
        
        func deactivateMinWidthConstraintIfNeeded() {
            let existedConstraints = constraints.filter { constraint in
                guard constraint.relation == .greaterThanOrEqual else { return false }
                guard constraint.firstAttribute == .width else { return false }
                guard constraint.secondAttribute == .notAnAttribute else { return false }
                return true
            }
            if existedConstraints.isEmpty { return }
            NSLayoutConstraint.deactivate(existedConstraints)
        }
        
        func deactivateMaxWidthConstraintIfNeeded() {
            let existedConstraints = constraints.filter { constraint in
                guard constraint.relation == .lessThanOrEqual else { return false }
                guard constraint.firstAttribute == .width else { return false }
                guard constraint.secondAttribute == .notAnAttribute else { return false }
                return true
            }
            if existedConstraints.isEmpty { return }
            NSLayoutConstraint.deactivate(existedConstraints)
        }
        
        func deactivateMinHeightConstraintIfNeeded() {
            let existedConstraints = constraints.filter { constraint in
                guard constraint.relation == .greaterThanOrEqual else { return false }
                guard constraint.firstAttribute == .height else { return false }
                guard constraint.secondAttribute == .notAnAttribute else { return false }
                return true
            }
            if existedConstraints.isEmpty { return }
            NSLayoutConstraint.deactivate(existedConstraints)
        }
        
        func deactivateMaxHeightConstraintIfNeeded() {
            let existedConstraints = constraints.filter { constraint in
                guard constraint.relation == .lessThanOrEqual else { return false }
                guard constraint.firstAttribute == .height else { return false }
                guard constraint.secondAttribute == .notAnAttribute else { return false }
                return true
            }
            if existedConstraints.isEmpty { return }
            NSLayoutConstraint.deactivate(existedConstraints)
        }
        
        guard minWidth.isValid || maxWidth.isValid || minHeight.isValid || maxHeight.isValid else {
            deactivateMinWidthConstraintIfNeeded()
            deactivateMaxWidthConstraintIfNeeded()
            deactivateMinHeightConstraintIfNeeded()
            deactivateMaxHeightConstraintIfNeeded()
            return self
        }

        translatesAutoresizingMaskIntoConstraints = false
        if let minWidth {
            deactivateMinWidthConstraintIfNeeded()
            let constraint = widthAnchor.constraint(greaterThanOrEqualToConstant: minWidth.constant)
            constraint.priority = minWidth.priority
            constraint.isActive = true
        }

        if let maxWidth {
            deactivateMaxWidthConstraintIfNeeded()
            let constraint = widthAnchor.constraint(lessThanOrEqualToConstant: maxWidth.constant)
            constraint.priority = maxWidth.priority
            constraint.isActive = true
        }

        if let minHeight {
            deactivateMinHeightConstraintIfNeeded()
            let constraint = heightAnchor.constraint(greaterThanOrEqualToConstant: minHeight.constant)
            constraint.priority = minHeight.priority
            constraint.isActive = true
        }

        if let maxHeight {
            deactivateMaxHeightConstraintIfNeeded()
            let constraint = heightAnchor.constraint(lessThanOrEqualToConstant: maxHeight.constant)
            constraint.priority = maxHeight.priority
            constraint.isActive = true
        }
        return self
    }
	
	func addSubviews(_ subviews: UIView...) {
		addSubviews(subviews)
	}
	
	func addSubviews(@ArrayBuilder<UIView> builder: () -> [UIView]) {
		let subviews = builder()
		addSubviews(subviews)
	}
	
	func addSubviews<T>(_ subviews: T) where T: Sequence, T.Element: UIView {
		subviews.forEach { subview in
			addSubview(subview)
		}
	}
	
	func fitSizeIfNeeded() {
		let systemLayoutSize = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
		let height = systemLayoutSize.height
		let width = systemLayoutSize.width
		if height != bounds.height {
			bounds.size.height = height
		}
		if width != bounds.width {
			bounds.size.width = width
		}
	}
    
    func superview(where predicate: (UIView) -> Bool) -> UIView? {
        superview(UIView.self, where: predicate)
    }
    
    func superview<SuperView: UIView>(_ type: SuperView.Type, where predicate: (SuperView) -> Bool) -> SuperView? {
        var targetSuperview: SuperView?
        var nextResponder = next
        while let unwrapResponder = nextResponder {
            if let nextSuperview = unwrapResponder as? SuperView {
                if predicate(nextSuperview) {
                    targetSuperview = nextSuperview
                    break
                }
            }
            nextResponder = unwrapResponder.next
        }
        return targetSuperview
    }

	func superview<SuperView: UIView>(_ type: SuperView.Type) -> SuperView? {
		guard let validSuperview = superview else { return nil }
		guard let matchedSuperview = validSuperview as? SuperView else {
			return validSuperview.superview(SuperView.self)
		}
		return matchedSuperview
	}
	
	@discardableResult
	func harden(axis: NSLayoutConstraint.Axis? = nil, intensity: UILayoutPriority = .required) -> Self {
		func hardenVertical() {
			setContentCompressionResistancePriority(intensity, for: .vertical)
			setContentHuggingPriority(intensity, for: .vertical)
		}
		func hardenHorizontal() {
			setContentCompressionResistancePriority(intensity, for: .horizontal)
			setContentHuggingPriority(intensity, for: .horizontal)
		}
		guard let axis = axis else {
			hardenVertical()
			hardenHorizontal()
			return self
		}
		switch axis {
		case .horizontal:
			hardenHorizontal()
		case .vertical:
			hardenVertical()
		@unknown default:
			break
		}
		return self
	}
	
	final class _UIShadowView: UIView { }
	var shadowView: _UIShadowView {
		guard let shadow = getAssociatedObject(self, &Associated.shadowViewKey) as? _UIShadowView else {
			let shadow = _UIShadowView(frame: bounds)
			shadow.isUserInteractionEnabled = false
			shadow.backgroundColor = .clear
			shadow.layer.masksToBounds = false
			shadow.layer.shouldRasterize = true
			shadow.layer.rasterizationScale = UIScreen.main.scale
			shadow.autoresizingMask = [
				.flexibleWidth,
				.flexibleHeight
			]
			setAssociatedObject(self, &Associated.shadowViewKey, shadow, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
			return shadow
		}
		return shadow
	}
	
	func roundCorners(corners: UIRectCorner = .allCorners,
					  cornerRadius: CGFloat = 0.0,
					  withShadowColor shadowColor: UIColor? = nil,
					  shadowOffset: (x: Double, y: Double) = (0, 0),
					  shadowRadius: CGFloat = 0,
					  shadowOpacity: Float = 0,
					  shadowExpansion: CGFloat = 0) {
		var bezier = UIBezierPath(
			roundedRect: bounds,
			byRoundingCorners: corners,
			cornerRadii: CGSize(width:cornerRadius, height:cornerRadius)
		)
		if cornerRadius > 0 {
			if #available(iOS 11.0, *), shadowColor == nil {
				layer.masksToBounds = true
				layer.cornerRadius = cornerRadius
				layer.maskedCorners = corners.caCornerMask
			} else {
				let shape = CAShapeLayer()
				shape.path = bezier.cgPath
				layer.mask = shape
			}
		} else {
            if #available(iOS 11.0, *), shadowColor == nil {
                layer.masksToBounds = false
                layer.cornerRadius = cornerRadius
                layer.maskedCorners = corners.caCornerMask
            } else {
                layer.mask = nil
            }
		}
		
		if let shadowColor = shadowColor {
			shadowView.frame = frame
			shadowView.layer.shadowColor = shadowColor.cgColor
			shadowView.layer.shadowOffset = CGSize(width: shadowOffset.x, height: shadowOffset.y)
			shadowView.layer.shadowRadius = shadowRadius
			shadowView.layer.shadowOpacity = shadowOpacity
			if shadowExpansion != 0 {
				let insets = UIEdgeInsets(
					top: -shadowExpansion,
					left: -shadowExpansion,
					bottom: -shadowExpansion,
					right: -shadowExpansion
				)
				bezier = UIBezierPath(
					roundedRect: bounds.inset(by: insets),
					byRoundingCorners: corners,
					cornerRadii: CGSize(width:cornerRadius, height:cornerRadius)
				)
			}
			shadowView.layer.shadowPath = bezier.cgPath
			if let superView = superview {
				superView.insertSubview(shadowView, belowSubview: self)
			}
		}
	}
}

#if DEBUG
@available(iOS 13.0, *)
extension UIView {

	var previewLayout: PreviewLayout {
		let previewSize = systemLayoutSizeFitting(
			CGSize(width: UIScreen.main.bounds.width, height: .greatestFiniteMagnitude),
			withHorizontalFittingPriority: .required,
			verticalFittingPriority: .fittingSizeLevel
		)
		return .fixed(width: previewSize.width, height: previewSize.height)
	}
	
	private struct Preview: UIViewRepresentable {
		
		let view: UIView

		func makeUIView(context: Context) -> UIView { view }

		func updateUIView(_ uiView: UIView, context: Context) { }
	}

	var preview: some View {
		Preview(view: self)
			.previewLayout(previewLayout)
	}
}
#endif

extension UIView.AutoresizingMask {
    
    static var autoResize: UIView.AutoresizingMask {
        [.flexibleWidth, .flexibleHeight]
    }
}
