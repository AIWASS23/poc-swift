import SwiftUI

struct Polygon: Shape {
    var corners: Int
    var size: CGSize

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let center = CGPoint(x: rect.midX, y: rect.midY)
        for i in 0..<corners {
            let angle = CGFloat(Double.pi * 2 / Double(corners) * Double(i))
            let point = CGPoint(x: center.x + size.width * cos(angle), y: center.y + size.height * sin(angle))
            if i == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        path.closeSubpath()

        return path
    }
}
