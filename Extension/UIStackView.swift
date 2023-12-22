#if canImport(UIKit)
import UIKit

extension UIStackView {
    /// Adds multiple arranged subviews to the current stack.
    ///
    ///     let stack = UIStackView()
    ///     let view1 = UIView()
    ///     let view2 = UIView()
    ///     stack.addArrangedSubviews(view1, view2)
    ///
    /// - Parameter views: The views to add as arranged subviews.
    @discardableResult
    func addArrangedSubviews(_ views: UIView...) -> Self {
        for view in views {
            addArrangedSubview(view)
        }

        return self
    }
}
#endif
