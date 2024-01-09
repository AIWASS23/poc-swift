import SwiftUI

/*
Esta extensão permite definir o tamanho de uma View de forma 
proporcional à largura e à altura da tela do dispositivo.

Rectangle()
    .proportionalFrame(width: 0.8, height: 0.5)
*/

extension View {
    func propotionalFrame(
        width: CGFloat, 
        height: CGFloat, 
        isSquared: Bool = false, 
        alignment: Alignment = .center
        ) -> some View {
            let finalWidth = UIScreen.main.bounds.width * width
            let finalHeight = isSquared ? finalWidth : UIScreen.main.bounds.height * height
            return frame(width: finalWidth, height: finalHeight)
    }
}