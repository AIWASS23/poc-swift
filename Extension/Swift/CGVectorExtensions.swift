
import Foundation

extension CGVector {
   
    var angle: CGFloat {
        return atan2(dy, dx)
    }

    var magnitude: CGFloat {
        return sqrt((dx * dx) + (dy * dy))
    }
}

extension CGVector {
    init(angle: CGFloat, magnitude: CGFloat) {
        self.init(dx: magnitude * cos(angle), dy: magnitude * sin(angle))
    }
}

extension CGVector {
    
    static func * (vector: CGVector, scalar: CGFloat) -> CGVector {
        return CGVector(dx: vector.dx * scalar, dy: vector.dy * scalar)
    }

    static func * (scalar: CGFloat, vector: CGVector) -> CGVector {
        return CGVector(dx: scalar * vector.dx, dy: scalar * vector.dy)
    }

    static func *= (vector: inout CGVector, scalar: CGFloat) {
        vector.dx *= scalar
        vector.dy *= scalar
    }

    static prefix func - (vector: CGVector) -> CGVector {
        return CGVector(dx: -vector.dx, dy: -vector.dy)
    }
}