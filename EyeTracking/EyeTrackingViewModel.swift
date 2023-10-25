//
//  EyeTrackingViewModel.swift
//  Eyes
//
//  Created by Marcelo De Araújo on 25/10/23.
//

import Foundation
import UIKit
import AVFoundation

class EyeTrackingViewModel: NSObject, ObservableObject {
    @Published var position: CGPoint = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
    @Published var cameraAccessGranted: Bool = false {
        didSet {
            if cameraAccessGranted {
                DispatchQueue.main.async {
                    self.objectWillChange.send()
                }
            }
        }
    }

    var isCenterPositionSet: Bool = false
    var centerPosition: CGPoint = CGPoint(x: 0.5, y: 0.5)

    func setCenterPosition(eyePosition: CGPoint) {
            centerPosition = eyePosition
            isCenterPositionSet = true
        }

    func getRelativeEyePosition(eyePosition: CGPoint) -> CGPoint {
        return CGPoint(x: eyePosition.x - centerPosition.x, y: eyePosition.y - centerPosition.y)
    }

    override init() {
        super.init()
        requestCameraAccess()
    }

    func requestCameraAccess() {
        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
            DispatchQueue.main.async {
                self?.cameraAccessGranted = granted
            }
        }
    }
}
