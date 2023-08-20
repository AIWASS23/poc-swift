//
//  RadarView.swift
//  ChartsPOC
//
//  Created by Marcelo De Araújo on 20/08/23.
//

import SwiftUI

@available(macOS 10.15, *)
struct RadarView: View {
    let numberOfSides: Int
    let numberOfRings: Int

    @State var size: CGFloat = 0

    @State var radialLinesColor: Color
    @State var radialLinesWidth: CGFloat

    @State var labelColor: Color
    @State var labelFont: Font

    @State var polygonLinesColor: Color
    @State var polygonLinesWidth: CGFloat

    let data: [RadarChartValues]
    let labels: [String]

    init(numberOfSides: Int = -1,
         numberOfRings: Int = 5,
         size: CGFloat = 0,
         radialLinesColor: Color = Color.gray.opacity(0.5),
         radialLinesWidth: CGFloat = 1,
         labelColor: Color = Color.black,
         labelFont: Font = Font.system(size: 16),
         polygonLinesColor: Color = Color.gray.opacity(0.5),
         polygonLinesWidth: CGFloat = 1.5,
         data: [RadarChartValues],
         labels: [String]) {

        if numberOfSides == -1 {
            self.numberOfSides = labels.count
        }
        else {
            self.numberOfSides = numberOfSides
        }
        self.numberOfRings = numberOfRings
        self.size = size
        self.radialLinesColor = radialLinesColor
        self.radialLinesWidth = radialLinesWidth
        self.labelColor = labelColor
        self.labelFont = labelFont
        self.polygonLinesColor = polygonLinesColor
        self.polygonLinesWidth = polygonLinesWidth
        self.data = data
        self.labels = labels
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                chartView
            }
            .onAppear() {
                size = geometry.size.width
            }
            .frame(width: size, height: size)
        }
    }
}

@available(macOS 10.15, *)
extension RadarView {
    private var chartView: some View {
        ZStack {
            drawRadialLines

            drawSizedPolygons

            drawLabels

            drawDataValueShapes
        }
        .scaleEffect(getDynamicScaleToLabelLength())
    }

    private var drawDataValueShapes : some View {
        ForEach(data) { dataShape in
            RadarDataShape(dataValues: dataShape.values, roundCorners: dataShape.roundedCorners)
                .foregroundColor(dataShape.color)
        }
    }

    // TODO: not final - long text looks bad
    private func getDynamicScaleToLabelLength() -> CGFloat {
        let longestLabel = CGFloat(longestWidth() ?? 0) * 0.02
        return 0.9 - longestLabel
    }

    private func longestWidth() -> Int? {
        labels.max(by: {$1.count > $0.count } )?.count
    }

    private func longest() -> CGFloat? {
        labels.max(by: {$1.count > $0.count } )?.widthOfString(usingFont: .systemFont(ofSize: 16))
    }

    private var drawRadialLines: some View {
        ForEach(0..<numberOfSides, id: \.self) { sideIndex in
            let angle = 2 * .pi * Double(sideIndex) / Double(numberOfSides)
            Path { path in

                let center = CGPoint(x: size / 2, y: size / 2)
                path.move(to: center)
                let xPosition = center.x - CGFloat(sin(angle)) * size / 2
                let yPosition = center.y - CGFloat(cos(angle)) * size / 2
                let point = CGPoint(x: xPosition, y: yPosition)
                path.addLine(to: point)
            }
            .stroke(radialLinesColor, lineWidth: radialLinesWidth)
        }
    }

    private var drawSizedPolygons: some View {
        ForEach(0..<numberOfRings, id: \.self) { ringIndex in
            let ringSize = CGFloat(ringIndex + 1) / CGFloat(numberOfRings) * 0.5
            let radius = size * ringSize

            PolygonView(numberOfSides: numberOfSides, radius: radius)
                .stroke(polygonLinesColor, lineWidth: polygonLinesWidth)
        }
    }
    private var drawLabels: some View {
        ForEach(0..<numberOfSides, id: \.self) { i in
            Text(labels[i])
                .font(labelFont)
                .foregroundColor(labelColor)
                .frame(width: 140, height: 10)
                .rotationEffect(.degrees(mirrorLabel(index: i)))
                .background(Color.clear)
                .offset(x: labelLengthOffset(index: i))
                .rotationEffect(rotateToCorner(index: i))
                .rotationEffect(Angle(degrees: -90))
        }
    }

    private func rotateToCorner(index: Int) -> Angle {
        .radians(
            Double(radAngle_fromFraction(numerator: index, denominator: numberOfSides))
        )
    }

    private func mirrorLabel(index: Int) -> Double {
        (degAngle_fromFraction(numerator: index, denominator: numberOfSides) > 180 && degAngle_fromFraction(numerator: index, denominator: numberOfSides) < 360)
        ? 180 : 0
    }

    private func labelLengthOffset(index: Int) -> CGFloat {
        return (size + 10 ) / 2 + labels[index].widthOfString(usingFont: .systemFont(ofSize: 16)) / 2
    }

    private func deg2rad(_ number: CGFloat) -> CGFloat {
        return number * .pi / 180
    }

    private func radAngle_fromFraction(numerator:Int, denominator: Int) -> CGFloat {
        return deg2rad(360 * (CGFloat((numerator))/CGFloat(denominator)))
    }

    private func degAngle_fromFraction(numerator:Int, denominator: Int) -> CGFloat {
        return 360 * (CGFloat((numerator))/CGFloat(denominator))
    }
}


@available(macOS 10.15, *)
struct SwiftUIView_Previews: PreviewProvider {
    static let dummyValues = [0.5, 0.7, 0, 0.6, 0.7, 0.5, 0.1]
    static let dummyValues2 = [0.2, 0.3, 0.7, 0.9, 0.2, 0.9, 0.5]
    static let dummyLabels = ["abbbbbb", "bbbbbb", "cbbbbbb", "dbbbbbb", "ebbbbbb", "fbbbbbb", "gbbbbbb"]

    static var previews: some View {
        RadarView(numberOfRings: 5,
                  data: [
                    RadarChartValues(values: dummyValues, color: Color.red.opacity(0.3), rounded: 0.8),
                    RadarChartValues(values: dummyValues2, color: Color.green.opacity(0.5), rounded: 0.9)
                  ], labels: dummyLabels)
    }
}

