import UIKit

class JustifiedLabel: InsetsLabel {

    var characterSpacing: Double = 20 {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    private lazy var textLayer = CATextLayer.make {
        $0.alignmentMode = .justified
        $0.contentsScale = UIScreen.main.scale
    }
    
    override var textColor: UIColor! {
        get {
            guard let cgColor = textLayer.foregroundColor else { return .clear }
            return UIColor(cgColor: cgColor)
        }
        set {
            textLayer.foregroundColor = newValue?.cgColor
        }
    }
    
    override var text: String? {
        get { super.text }
        set {
            super.text = newValue
            textLayer.string = newValue.orEmpty + "\n "
        }
    }
    
    override var font: UIFont! {
        get { super.font }
        set {
            super.font = newValue
            textLayer.font = newValue
            textLayer.fontSize = newValue.pointSize
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(textLayer)
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        textLayer.frame = layer.bounds.inset(by: textEdgeInsets)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        if let text {
            let spaceCount = text.count.cgFloat - 1.0
            size.width += spaceCount * characterSpacing
        }
        return size
    }

}
