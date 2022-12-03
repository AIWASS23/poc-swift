//
//  
//  ProgressView
//
//  Created by Marcelo De Araújo on 04/12/22.
//

import UIKit

extension Array where Element: UIColor {
    func intermediate(percentage: CGFloat) -> UIColor {
        let percentage = Swift.max(Swift.min(percentage, 100), 0) / 100
        switch percentage {
        case 0: return first ?? .clear
        case 1: return last ?? .clear
        default:
            let approxIndex = percentage / (1 / CGFloat(count - 1))
            let firstIndex = Int(approxIndex.rounded(.down))
            let secondIndex = Int(approxIndex.rounded(.up))
            let fallbackIndex = Int(approxIndex.rounded())
            
            let firstColor = self[firstIndex]
            let secondColor = self[secondIndex]
            let fallbackColor = self[fallbackIndex]
            
            var (r1, g1, b1, a1): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
            var (r2, g2, b2, a2): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
            guard firstColor.getRed(&r1, green: &g1, blue: &b1, alpha: &a1) else { return fallbackColor }
            guard secondColor.getRed(&r2, green: &g2, blue: &b2, alpha: &a2) else { return fallbackColor }
            
            let intermediatePercentage = approxIndex - CGFloat(firstIndex)
            return UIColor(
                red: CGFloat(r1 + (r2 - r1) * intermediatePercentage),
                green: CGFloat(g1 + (g2 - g1) * intermediatePercentage),
                blue: CGFloat(b1 + (b2 - b1) * intermediatePercentage),
                alpha: CGFloat(a1 + (a2 - a1) * intermediatePercentage)
            )
        }
    }
}


extension UIColor {
    private func makeColor(componentDelta: CGFloat) -> UIColor {
        var red: CGFloat = 0
        var blue: CGFloat = 0
        var green: CGFloat = 0
        var alpha: CGFloat = 0
        
        // Extraia os componentes RGB do
        // UIColor atual

        getRed(
            &red,
            green: &green,
            blue: &blue,
            alpha: &alpha
        )
        
        /* Cria uma nova UIColor modificando cada component
        por componentDelta, tornando o novo UIColor
        mais claro ou mais escuro. */

        return UIColor(
            red: add(componentDelta, toComponent: red),
            green: add(componentDelta, toComponent: green),
            blue: add(componentDelta, toComponent: blue),
            alpha: alpha
        )
    }
    
    /* Agregar valor ao componente garantindo que o resultado seja
        entre 0 e 1 */
        
    private func add(_ value: CGFloat, toComponent: CGFloat) -> CGFloat {
        return max(0, min(1, toComponent + value))
    }
    
    func lighter(componentDelta: CGFloat = 0.1) -> UIColor {
        return makeColor(componentDelta: componentDelta)
    }
    
    func darker(componentDelta: CGFloat = 0.1) -> UIColor {
        return makeColor(componentDelta: -1*componentDelta)
    }
}
