import Foundation
import SwiftUI

#if os(tvOS)

/*
A extensão onRotate oferece uma maneira de associar ações a mudanças na orientação do dispositivo. 
Para sistemas tvOS, ela atualmente executa uma ação específica de paisagem à esquerda, enquanto para 
outros sistemas, ela permite a execução de ações personalizadas em resposta às mudanças na orientação 
do dispositivo.
*/

enum UIDeviceOrientation : Int, @unchecked Sendable {
    
    case unknown = 0
    case portrait = 1 
    case portraitUpsideDown = 2 
    case landscapeLeft = 3 
    case landscapeRight = 4 
    case faceUp = 5 
    case faceDown = 6 
}

extension View {
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        action(UIDeviceOrientation.landscapeLeft)
        
        return self
    }
}
#elseif !os(macOS)

struct DeviceRotationViewModifier: ViewModifier {
    let action: (UIDeviceOrientation) -> Void
    
    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(
                NotificationCenter.default.publisher(
                    for: UIDevice.orientationDidChangeNotification
                    )
                ) { _ in
                    action(UIDevice.current.orientation)
                }
    }
}

extension View {
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationViewModifier(action: action))
    }
}
#endif

