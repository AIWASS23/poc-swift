//
//  LoginView.swift
//  StoreApp
//
//  Created by Marcelo de Araújo on 09/12/22.
//

import SwiftUI
import LocalAuthentication

struct LoginView: View {

    @State private var isUnlocked = false
    @State private var failedAuth = ""
    
    var body: some View {
        if isUnlocked {
            HomeView()
        } else {
            VStack {
                Text("Welcome to")
                Text("Courses")
                    .font(.largeTitle)
                Button(action: authenticate() ) {
                    Label("Login with FaceID", systemImage: "faceid")
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.white))
                }
                
                Text(failedAuth)
                    .padding()
                    .opacity(failedAuth.isEmpty ? 0.0 : 1.0)
            }
        }
    }

    private func authenticate() {
        var error: NSError?
        let laContext = LAContext()
        
        if laContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Need access to authenticate"
            
            laContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
                DispatchQueue.main.async {
                    if success {
                        isUnlocked = true
                        failedAuth = ""
                    } else {
                        print(error?.localizedDescription ?? "error")
                        failedAuth = error?.localizedDescription ?? "error"
                    }
                }
            }
        } else {
            
        }
    }
}