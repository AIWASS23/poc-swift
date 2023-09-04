//
//  CustomNavView.swift
//  CustomNavigationView
//
//  Created by Ganesh on 23/08/23.
//

import SwiftUI

struct CustomNavView<Content:View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    var body: some View {
        NavigationView {
            CustomNavBarContainerView {
                 content
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(.stack)
    }
}

