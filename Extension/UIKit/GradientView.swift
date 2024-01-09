import UIKit

class GradientView: UIView {
    
    typealias GradientLayer = CAGradientLayer
    
    override class var layerClass: AnyClass { GradientLayer.self }
    
    var gradientColors: GradientColors = [] {
        willSet {
            gradientLayer.setColors(newValue)
        }
    }
    
    init(direction: CGVector = .right, gradientColors: GradientColors = []) {
        super.init(frame: .zero)
        self.gradientColors = gradientColors
        self.gradientLayer.setColors(gradientColors)
        setDirection(direction)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func refill(@ArrayBuilder<ColorStop> _ gradientBuilder: GradientColorsBuilder) {
        gradientColors = gradientBuilder()
    }

    func setDirection(_ vector: CGVector) {
        gradientLayer.setDirection(vector)
    }
}

extension GradientView {
    
    convenience init(direction: CGVector = .right, @ArrayBuilder<ColorStop> _ gradientBuilder: GradientColorsBuilder) {
        let gradientColors = gradientBuilder()
        self.init(direction: direction, gradientColors: gradientColors)
    }
    
    var gradientLayer: GradientLayer {
        layer as! GradientLayer
    }
}
