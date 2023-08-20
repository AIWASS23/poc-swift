//
//  RadarChartValues.swift
//  ChartsPOC
//
//  Created by Marcelo De Araújo on 20/08/23.
//

import SwiftUI

@available(macOS 10.15, *)
struct RadarChartValues : Identifiable {
    let values: [Double]
    let color: Color
    let roundedCorners: CGFloat
    let id = UUID()

    internal init(
        values: [Double],
        color: Color = Color.pink.opacity(0.8),
        rounded: CGFloat = 0.0 ) {

            self.values = values
            self.color = color
            self.roundedCorners = rounded
        }
}
