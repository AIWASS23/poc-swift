import Foundation
import SwiftUI


struct customButtonModifier: ViewModifier {
    
    var backGroundColor: Color
    
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .foregroundColor(.white)
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            .background(backGroundColor)
            .cornerRadius(10)
            .shadow(radius: 10)
    }
}

struct customStyle: ButtonStyle{
    
    var scaleAmount: CGFloat
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scaleAmount : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
    }
}


extension View {
    
    func withCustomModifier(backGroundColor:Color = .blue) -> some View {
        modifier(customButtonModifier(backGroundColor: backGroundColor))
    }
    
    func withCustomStyle(scaleAmount: CGFloat = 0.9) -> some View {
        buttonStyle(customStyle(scaleAmount: scaleAmount))
    }
}
