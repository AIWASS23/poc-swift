import Foundation
import SwiftUI

/*

let swiftUIView = Text("Hello, SwiftUI!") 
// Sua View do SwiftUI que deseja converter em UIImage
let image = swiftUIView.toUIImage() 
// Converte a View para UIImage

*/

extension View {
    
    /*
    Esta função altera a View para UIView e, em seguida, chama outra função para converter o UIView 
    recém-criado em UIImage.
    */
    func toUIImage() -> UIImage {
        let controller = UIHostingController(rootView: self)
        
        controller.view.frame = CGRect(x: 0, y: CGFloat(Int.max), width: 1, height: 1)
        UIApplication.shared.windows.first!.rootViewController?.view.addSubview(controller.view)
        
        let size = controller.sizeThatFits(in: UIScreen.main.bounds.size)
        controller.view.bounds = CGRect(origin: .zero, size: size)
        controller.view.sizeToFit()
        
        let image = controller.view.toUIImage()
        controller.view.removeFromSuperview()
        return image
    }
}

extension UIView {
    // This is the function to convert UIView to UIImage.
    public func toUIImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
