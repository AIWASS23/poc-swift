//
//  ContentView.swift
//  Eyes
//
//  Created by Marcelo de Araújo on 25/10/2023.
//

import SwiftUI
import CoreData
import AVFoundation
import Vision

struct ContentView: View {
    @StateObject var viewModel = EyeTrackingViewModel()

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            CameraViewControllerRepresentable(viewModel: viewModel)
                .ignoresSafeArea()
                .opacity(0)

            if !viewModel.isCenterPositionSet {
                Circle()
                    .fill(Color.green)
                    .frame(width: 20, height: 20)
                    .position(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)

                Text("Please look at the center of the screen")
                    .foregroundColor(.white)
                    .position(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY - 30)
            } else {
                Rectangle()
                    .fill(Color.white)
                    .frame(width: 50, height: 50)
                    .position(viewModel.position)
                    .edgesIgnoringSafeArea(.all)
            }

            VStack {
                Text("X: \(viewModel.position.x, specifier: "%.2f")")
                    .foregroundColor(.white)
                Text("Y: \(viewModel.position.y, specifier: "%.2f")")
                    .foregroundColor(.white)
                if viewModel.isCenterPositionSet {
                    Text("Center X: \(viewModel.centerPosition.x, specifier: "%.2f")")
                        .foregroundColor(.white)
                    Text("Center Y: \(viewModel.centerPosition.y, specifier: "%.2f")")
                        .foregroundColor(.white)
                }
            }
            .position(x: UIScreen.main.bounds.midX, y: 30)
        }
        .onAppear {
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    viewModel.cameraAccessGranted = true
                } else {
                    print("Camera access not granted")
                }
            }
        }
    }
}
