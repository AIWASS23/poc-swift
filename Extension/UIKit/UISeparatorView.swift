import UIKit

class UISeparatorView: UIView {

    let axis: NSLayoutConstraint.Axis
    let color: UIColor
    let thickness: Double
    init(axis: NSLayoutConstraint.Axis = .horizontal,
         color: UIColor = .white,
         thickness: Double = 1.0,
         frame: CGRect = .zero)
    {
        self.axis = axis
        self.color = color
        self.thickness = thickness
        super.init(frame: frame)
        prepare()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepare() {
        backgroundColor = color
        switch axis {
        case .horizontal:
            heightAnchor.constraint(equalToConstant: thickness).isActive = true
        case .vertical:
            widthAnchor.constraint(equalToConstant: thickness).isActive = true
        @unknown default:
            fatalError()
        }
    }

}
