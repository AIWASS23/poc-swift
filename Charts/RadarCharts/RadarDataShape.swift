//
//  RadarDataShape.swift
//  ChartsPOC
//
//  Created by Marcelo De Araújo on 20/08/23.
//

import SwiftUI

@available(macOS 10.15, *)
struct RadarDataShape: Shape {
    let numberOfSides: Int
    let dataValues: [Double]
    let roundFactor: Double

    /**
     roundCorners = 0 -> sharp edges
     roundCOrner = 1 -> max rounded
     */
    init(dataValues: [Double], roundCorners: Double) {
        self.numberOfSides = dataValues.count
        self.dataValues = dataValues
        if (roundCorners > 1 || roundCorners < 0) {
            print("Error, cornerRadius too big")
        }
        self.roundFactor = 1 - roundCorners
    }

    func factoredMiddle(negated: Double, factored: Double) -> Double {
        negated * (1 - roundFactor) + factored * roundFactor
    }

    func factoredMiddlePoint(negated: CGPoint, factored: CGPoint) -> CGPoint {
        return CGPoint(
            x: factoredMiddle(negated: negated.x, factored: factored.x),
            y: factoredMiddle(negated: negated.y, factored: factored.y)
        )
    }

    func path(in rect: CGRect) -> Path {
        Path { path in
            let center = CGPoint(x: rect.width / 2.0, y: rect.height / 2.0)
            let angle = .pi * 2.0 / Double(numberOfSides)

            for i in 0..<numberOfSides {
                let radius = rect.width / 2.0 * dataValues[i]

                let xPosition = center.x - CGFloat(sin(Double(i) * angle)) * radius
                let yPosition = center.y - CGFloat(cos(Double(i) * angle)) * radius
                let point = CGPoint(x: xPosition, y: yPosition)

                if i == 0 {
                    path.move(to: point)
                }

                // point and nextPoint
                let nextIndex = (i + 1) % numberOfSides
                let nextRadius = rect.width / 2.0 * dataValues[nextIndex]
                let nextXPosition = center.x - CGFloat(sin(Double(nextIndex) * angle)) * nextRadius
                let nextYPosition = center.y - CGFloat(cos(Double(nextIndex) * angle)) * nextRadius
                let nextPoint = CGPoint(x: nextXPosition, y: nextYPosition)

                let midPointNext = factoredMiddlePoint(negated: nextPoint, factored: point)

                if i == 0 {
                    let previousIndex = i == 0 ? numberOfSides - 1 : i - 1
                    let previousRadius = rect.width / 2.0 * dataValues[previousIndex]
                    let previousXPosition = center.x - CGFloat(sin(Double(previousIndex) * angle)) * previousRadius
                    let previousYPosition = center.y - CGFloat(cos(Double(previousIndex) * angle)) * previousRadius
                    let previousPoint = CGPoint(x: previousXPosition, y: previousYPosition)

                    // MidPoint from previous and current
                    let midPointPrev = factoredMiddlePoint(negated: previousPoint, factored: point)

                    path.addCurve(to: midPointPrev, control1: point, control2: midPointPrev)
                    path.addQuadCurve(to: midPointNext, control: point)


                }
                else {
                    path.addQuadCurve(to: midPointNext, control: point)
                }
            }
            path.closeSubpath()
        }
    }
}



@available(macOS 10.15, *)
struct RadarDataShape_Previews: PreviewProvider {
    static var previews: some View {
        let dummyValues = [1, 1, 0.5, 1, 0.5, 1, 0.5]
        RadarDataShape(dataValues: dummyValues, roundCorners: 0)
            .foregroundColor(Color.purple.opacity(0.3))
    }
}

