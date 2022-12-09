//
//  Extension.swift
//  StoreApp
//
//  Created by Marcelo de Araújo on 09/12/22.
//

import Foundation

extension Course {
    static var sample: [Course] {
        [
            Course(name: "Mastering SwiftUI 3", duration: "1h 20m", category: "SwiftUI"),
            Course(name: "UIKit in Depth", duration: "2h 30m", category: "UIKit"),
            Course(name: "Machine Learning by Example", duration: "4h 20m", category: "iOS Machine Learning")
        ]
    }
}