//
//  CameraViewController.swift
//  Eyes
//
//  Created by Marcelo De Araújo on 25/10/23.
//

import Foundation
import AVFoundation
import UIKit
import Vision

class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    var viewModel: EyeTrackingViewModel

    private let captureSession = AVCaptureSession()
    private var leftEyeRequest = VNDetectFaceLandmarksRequest()
    private var rightEyeRequest = VNDetectFaceLandmarksRequest()

    init(viewModel: EyeTrackingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupFrontCamera()
        DispatchQueue.global().async {
            self.captureSession.startRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        DispatchQueue.global().async {
            self.captureSession.stopRunning()
        }
    }

    private func setupFrontCamera() {
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else { return }

        do {
            let input = try AVCaptureDeviceInput(device: camera)
            let output = AVCaptureVideoDataOutput()
            output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))

            captureSession.sessionPreset = .high
            captureSession.addInput(input)
            captureSession.addOutput(output)
        } catch {
            print("Error setting up front camera: \(error)")
        }
    }

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])

        do {
            try imageRequestHandler.perform([leftEyeRequest, rightEyeRequest])

            guard let leftEye = leftEyeRequest.results?.first as? VNFaceObservation,
                  let rightEye = rightEyeRequest.results?.first as? VNFaceObservation else { return }

            DispatchQueue.main.async {
                let leftEyePosition = self.getEyePosition(on: leftEye)
                let rightEyePosition = self.getEyePosition(on: rightEye)

                let eyePosition = CGPoint(x: (leftEyePosition.x + rightEyePosition.x) / 2,
                                          y: (leftEyePosition.y + rightEyePosition.y) / 2)

                if !self.viewModel.isCenterPositionSet {
                    self.viewModel.setCenterPosition(eyePosition: eyePosition)
                } else {
                    self.viewModel.position = CGPoint(x: eyePosition.y * UIScreen.main.bounds.width,
                                                      y: (1 - eyePosition.x) * UIScreen.main.bounds.height)
                }
            }
        } catch {
            print("Error detecting eye landmarks: \(error)")
        }
    }

    private func getEyePosition(on faceObservation: VNFaceObservation) -> CGPoint {
        guard let leftEye = faceObservation.landmarks?.leftEye,
              let rightEye = faceObservation.landmarks?.rightEye else { return CGPoint(x: 0.5, y: 0.5) }

        let leftEyePoints = leftEye.pointsInImage(imageSize: CGSize(width: 1, height: 1))
        let rightEyePoints = rightEye.pointsInImage(imageSize: CGSize(width: 1, height: 1))

        let leftEyePosition = CGPoint.average(points: leftEyePoints)
        let rightEyePosition = CGPoint.average(points: rightEyePoints)

//        let eyePosition = CGPoint(x: (leftEyePosition.x + rightEyePosition.x))
        let eyePosition = CGPoint(x: (leftEyePosition.x + rightEyePosition.x) / 2, y: (leftEyePosition.y + rightEyePosition.y) / 2)

        return eyePosition
    }

}
