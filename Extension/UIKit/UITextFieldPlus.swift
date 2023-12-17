import UIKit

extension UITextField {
    
    struct Associated {
        static var placeholderColor = UUID()
    }
}

extension KK where Base: UITextField {
    
    public var placeholderColor: UIColor? {
        
        get {
            getAssociatedObject(self, &UITextField.Associated.placeholderColor) as? UIColor
        }
        
        nonmutating set {
            guard let newValue else { return }
            setAssociatedObject(self, &UITextField.Associated.placeholderColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: newValue,
                .font: base.font ?? .systemFont(ofSize: 12)
            ]
            base.attributedPlaceholder = NSMutableAttributedString(string: base.placeholder ?? "", attributes: attributes)
        }
    }
}
