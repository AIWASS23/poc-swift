import UIKit

final class DashLine: UIView {
	
	private let axis: NSLayoutConstraint.Axis
	private let color: UIColor
	private let linePattern: [NSNumber]
	init(axis: NSLayoutConstraint.Axis = .horizontal,
		 color: UIColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1),
		 linePattern: [NSNumber] = [5, 5],
		 frame: CGRect = .zero)
	{
		self.axis = axis
		self.color = color
		self.linePattern = linePattern
		super.init(frame: frame)
		prepare()
	}
	
	private func prepare() {
		backgroundColor = .none
		shapeLayer.strokeColor = color.cgColor
		shapeLayer.lineDashPattern = linePattern
	}
	
	required init?(coder: NSCoder) { nil }
	
	override class var layerClass: AnyClass {
		CAShapeLayer.self
	}
	
	private var shapeLayer: CAShapeLayer {
		layer as! CAShapeLayer
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		shapeLayer.lineWidth = axis == .horizontal ? bounds.height : bounds.width
		let cgPath = CGMutablePath()
		let hPoint = [
			CGPoint(x: 0, y: bounds.height/2.0),
			CGPoint(x: bounds.width, y: bounds.height/2.0)
		]
		let vPoint = [
			CGPoint(x: bounds.width/2.0, y: 0),
			CGPoint(x: bounds.width/2.0, y: bounds.height)
		]
		let points = axis == .horizontal ? hPoint : vPoint
		cgPath.addLines(between: points)
		shapeLayer.path = cgPath
	}
}
