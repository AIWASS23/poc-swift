//
//  Execute.swift
//  ReedWriteCycle (iOS)
//
//  Created by Kevin Mullins on 7/7/22.
//

import Foundation
import SwiftUI

class Execute {
    typealias Perform = () -> Void
    
    static func onMain(perform: @escaping Perform) {
        DispatchQueue.main.async {
            perform()
        }
    }
    
    static func afterDelay(seconds:Double, perform: @escaping Perform) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            perform()
        }
    }
}
