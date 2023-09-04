//
//  CustomNavBarView.swift
//  CustomNavigationView
//
//  Created by Ganesh on 22/08/23.
//

import SwiftUI

struct CustomNavBarView: View {

    @Environment(\.presentationMode) var presentationMode
    let title:String
    let subtitle:String?
    let showBackBtn:Bool
    var body: some View {
        HStack{
            if showBackBtn{
                backButton
            }
           
            Spacer()
            titleSection
            Spacer()
            
            if showBackBtn{
                backButton
                .opacity(0)
            }
        }
        .padding()
        .tint(.white)
        .foregroundColor(.white)
        .font(.headline)
        .background(
            Color.pink.opacity(0.5).ignoresSafeArea(edges: .top)
        )
    }
}

extension CustomNavBarView {
    
    private var backButton: some View{
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Image(systemName: "chevron.left")
        }
    }
    
    private var titleSection: some View{
        VStack(spacing: 4){
            Text(title)
                .font(.title)
                .fontWeight(.semibold)
            if let subtitle = subtitle{
                Text(subtitle)
            }
        }
    }
}

struct CustomNavBarView_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            CustomNavBarView(title: "Hi", subtitle: "hello", showBackBtn: true)
            Spacer()
        }
       
    }
}
