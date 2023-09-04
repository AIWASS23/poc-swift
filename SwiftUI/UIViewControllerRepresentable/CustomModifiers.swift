import Foundation
import SwiftUI


struct CustomButtonStyle:ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .fontWeight(.bold)
            .padding()
            .frame(maxWidth: .infinity)
            .foregroundColor(.white)
            .background(Color.pink.opacity(0.5))
            .shadow(radius: 10)
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}

extension View{
    
    func withCustomButtonStyle() -> some View{
        buttonStyle(CustomButtonStyle())
    }
}
