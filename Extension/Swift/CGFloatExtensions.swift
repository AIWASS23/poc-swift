import Foundation

extension CGFloat {
    var abs: CGFloat {
        return Swift.abs(self)
    }

    var ceil: CGFloat {
        return Foundation.ceil(self)
    }

    var degreesToRadians: CGFloat {
        return .pi * self / 180.0
    }

    var floor: CGFloat {
        return Foundation.floor(self)
    }

    var isPositive: Bool {
        return self > 0
    }

    var isNegative: Bool {
        return self < 0
    }

    var int: Int {
        return Int(self)
    }

    var float: Float {
        return Float(self)
    }

    var double: Double {
        return Double(self)
    }

    var radiansToDegrees: CGFloat {
        return self * 180 / CGFloat.pi
    }
}