import SwiftUI

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