import SwiftUI


extension View {
    
    func withPressableButtonStyle(scaleEffect:CGFloat = 0.9) -> some View {
        buttonStyle(PressableButtonStyle(scaleEffect: scaleEffect))
    }

    func withDefaultButtonFormmating(_ backgroundColor: Color = .blue) -> some View {
        modifier(DefaultButtonViewModifier(backgroundColor: backgroundColor))
    }
}

extension AnyTransition {
    
    static var rotating: AnyTransition {
        modifier(active:RotateViewModifier(rotationAngle: 180), identity: RotateViewModifier(rotationAngle: 0))
    }
    
    static func rotating(rotationAngle:Double) -> AnyTransition {
        modifier(active: RotateViewModifier(rotationAngle: rotationAngle), identity: RotateViewModifier(rotationAngle: 0))
    }
    
    static var rotationOn:AnyTransition {
        asymmetric(insertion: .rotating, removal: .move(edge: .leading))
    }
}