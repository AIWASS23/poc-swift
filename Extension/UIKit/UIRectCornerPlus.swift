import UIKit

extension UIRectCorner {
    
    static var topCorners: UIRectCorner {
        [.topLeft, .topRight]
    }
    static var bottomCorners: UIRectCorner {
        [.bottomLeft, .bottomRight]
    }
    static var leftCorners: UIRectCorner {
        [.topLeft, .bottomLeft]
    }
    static var rightCorners: UIRectCorner {
        [.topRight, .bottomRight]
    }
    var topCorners: UIRectCorner {
        var result: UIRectCorner = []
        if contains(.topLeft) {
            result.formUnion(.topLeft)
        }
        if contains(.topRight) {
            result.formUnion(.topRight)
        }
        return result
    }
    var bottomCorners: UIRectCorner {
        var result: UIRectCorner = []
        if contains(.bottomLeft) {
            result.formUnion(.bottomLeft)
        }
        if contains(.bottomRight) {
            result.formUnion(.bottomRight)
        }
        return result
    }
    var leftCorners: UIRectCorner {
        var result: UIRectCorner = []
        if contains(.topLeft) {
            result.formUnion(.topLeft)
        }
        if contains(.bottomLeft) {
            result.formUnion(.bottomLeft)
        }
        return result
    }
    var rightCorners: UIRectCorner {
        var result: UIRectCorner = []
        if contains(.topRight) {
            result.formUnion(.topRight)
        }
        if contains(.bottomRight) {
            result.formUnion(.bottomRight)
        }
        return result
    }
}
