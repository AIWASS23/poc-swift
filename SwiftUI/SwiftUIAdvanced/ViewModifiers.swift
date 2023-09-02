import SwiftUI

struct DefaultButtonViewModifier: ViewModifier {

    let backgroundColor:Color
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 55)
            .background(backgroundColor)
            .cornerRadius(10)
            .shadow(radius: 10)
    }
}

struct RotateViewModifier: ViewModifier {
    let rotationAngle:Double
    
    init(rotationAngle: Double = 40.0) {
        self.rotationAngle = rotationAngle
    }
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(Angle(degrees: rotationAngle))
            .offset(
                x: rotationAngle != 0 ? UIScreen.main.bounds.width : 0,
                y: rotationAngle != 0 ? UIScreen.main.bounds.height : 0)
    }
}