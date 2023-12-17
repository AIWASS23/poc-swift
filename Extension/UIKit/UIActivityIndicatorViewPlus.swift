import UIKit

extension UIActivityIndicatorView {
    static var white: UIActivityIndicatorView {
        let indicator: UIActivityIndicatorView
        if #available(iOS 13.0, *) {
            indicator = UIActivityIndicatorView(style: .medium)
        } else {
            indicator = UIActivityIndicatorView(style: .white)
        }
        indicator.color = .white
        return indicator
    }
}
