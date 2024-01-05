
import Foundation

extension FloatingPoint {
    
    var abs: Self {
        return Swift.abs(self)
    }

    var isPositive: Bool {
        return self > 0
    }

    var isNegative: Bool {
        return self < 0
    }

    var ceil: Self {
        return Foundation.ceil(self)
    }

    var degreesToRadians: Self {
        return Self.pi * self / Self(180)
    }

    var floor: Self {
        return Foundation.floor(self)
    }

    var radiansToDegrees: Self {
        return self * Self(180) / Self.pi
    }
}

infix operator ±
// Tuple of plus-minus operation.

func ± <T: FloatingPoint>(lhs: T, rhs: T) -> (T, T) {
    return (lhs + rhs, lhs - rhs)
}

prefix operator ±

prefix func ± <T: FloatingPoint>(number: T) -> (T, T) {
    return 0 ± number
}
