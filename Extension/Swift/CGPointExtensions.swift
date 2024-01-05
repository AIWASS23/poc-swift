import Foundation

extension CGPoint {
   
    func distance(from point: CGPoint) -> CGFloat {
        return CGPoint.distance(from: self, to: point)
    }

    static func distance(from point1: CGPoint, to point2: CGPoint) -> CGFloat {
        // http://stackoverflow.com/questions/6416101/calculate-the-distance-between-two-cgpoints
        return sqrt(pow(point2.x - point1.x, 2) + pow(point2.y - point1.y, 2))
    }
}


extension CGPoint {
    
    static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    static func += (lhs: inout CGPoint, rhs: CGPoint) {
        lhs.x += rhs.x
        lhs.y += rhs.y
    }

    static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }

    static func -= (lhs: inout CGPoint, rhs: CGPoint) {
        lhs.x -= rhs.x
        lhs.y -= rhs.y
    }

    
    static func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
        return CGPoint(x: point.x * scalar, y: point.y * scalar)
    }

    static func *= (point: inout CGPoint, scalar: CGFloat) {
        point.x *= scalar
        point.y *= scalar
    }

    static func * (scalar: CGFloat, point: CGPoint) -> CGPoint {
        return CGPoint(x: point.x * scalar, y: point.y * scalar)
    }
}
