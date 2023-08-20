//
//  PolygonView.swift
//  ChartsPOC
//
//  Created by Marcelo De Araújo on 20/08/23.
//

import SwiftUI

@available(macOS 10.15, *)
struct PolygonView: Shape {
    let numberOfSides: Int
    let radius: CGFloat

    func path(in rect: CGRect) -> Path {
        Path { path in
            let center = CGPoint(x: rect.width / 2.0, y: rect.height / 2.0)
            let angle = .pi * 2.0 / Double(numberOfSides)

            for i in 0..<numberOfSides {
                let xPosition = center.x - CGFloat(sin(Double(i) * angle)) * radius
                let yPosition = center.y - CGFloat(cos(Double(i) * angle)) * radius
                let point = CGPoint(x: xPosition, y: yPosition)

                if i == 0 {
                    path.move(to: point)
                } else {
                    path.addLine(to: point)
                }
            }
            path.closeSubpath()
        }
    }
}

@available(macOS 10.15, *)
struct PolygonView_Previews: PreviewProvider {
    static var previews: some View {
        PolygonView(numberOfSides: 5, radius: 100)
            .frame(width: 200, height: 200)
    }
}
