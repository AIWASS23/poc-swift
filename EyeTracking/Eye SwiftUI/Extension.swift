//
//  Extension.swift
//  Eyes
//
//  Created by Marcelo De Araújo on 25/10/23.
//

import Foundation

extension CGPoint {
    static func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    static func average(points: [CGPoint]) -> CGPoint {
        let total = points.reduce(CGPoint.zero, +)
        return CGPoint(x: total.x / CGFloat(points.count), y: total.y / CGFloat(points.count))
    }
}
