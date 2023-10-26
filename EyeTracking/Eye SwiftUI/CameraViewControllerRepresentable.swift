//
//  CameraViewControllerRepresentable.swift
//  Eyes
//
//  Created by Marcelo De Araújo on 25/10/23.
//

import Foundation
import SwiftUI

struct CameraViewControllerRepresentable: UIViewControllerRepresentable {
    var viewModel: EyeTrackingViewModel

    func makeUIViewController(context: Context) -> CameraViewController {
        CameraViewController(viewModel: viewModel)
    }

    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {}
}
