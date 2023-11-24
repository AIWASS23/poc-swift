import Foundation

@resultBuilder
struct ConstraintBuilder {
    static func buildBlock(_ components: NSLayoutConstraint...) -> [NSLayoutConstraint] {
        components
    }
}

extension UIView {
    func activate(@ConstraintBuilder _ constraints: () -> [NSLayoutConstraint]) {
        NSLayoutConstraint.activate(constraints())
    }
}

// uso 
// activate {
//     label.topAnchor.constraint(equalTo: topAnchor)
//     label.leftAnchor .constraint(equalTo: leftAnchor)
//     label.bottomAnchor.constraint(equalTo: bottomAnchor)
//     label. rightAnchor.constraint(equalTo: rightAnchor)
// ｝