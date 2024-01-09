import Foundation
import SwiftUI

/*
extensões para facilitar o arredondamento de números (roundDouble) e para adicionar 
cantos arredondados a uma View (cornerRadius).

Rectangle()
    .cornerRadius(10, corners: [.topLeft, .bottomRight])

*/

extension Double{
    func roundDouble() -> String{
        return String(format: "%.0f",self)
    }
}

// Extension for adding rounded corners to specific corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners) )
    }
}

// Custom RoundedCorner shape used for cornerRadius extension above
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

