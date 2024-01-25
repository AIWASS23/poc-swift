import SwiftUI

/*
A extensão adiciona um método chamado isLight(threshold:) que determina se a cor 
representada pela instância de UIColor é considerada clara ou escura com base em um 
limiar de luminosidade.
*/

extension UIColor {
    func isLight(threshold: Float = 0.5) -> Bool {
        let originalCGColor = self.cgColor
        let RGBCGColor = originalCGColor.converted(to: CGColorSpaceCreateDeviceRGB(), intent: .defaultIntent, options: nil)
        guard let components = RGBCGColor?.components, components.count >= 3 else {
            return false
        }
        
        let brightness = Float(((components[0] * 299) + (components[1] * 587) + (components[2] * 114)) / 1000)
        return (brightness > threshold)
    }
}
