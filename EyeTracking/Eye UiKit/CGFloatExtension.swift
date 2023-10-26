//
//  CGFloatExtension.swift
//  Eye Tracking
//
//  Created by Marcelo De Araújo on 26/10/23.
//

import Foundation
import UIKit

extension CGFloat {

    func clamped(to: ClosedRange<CGFloat>) -> CGFloat {
        return
            to.lowerBound > self ? to.lowerBound : to.upperBound < self ? to.upperBound : self
    }
}
