import SwiftUI

extension Color {
    
    // Color -> UIColor
    func toUIColor() -> UIColor {
        if let components = self.cgColor?.components {
            return UIColor(displayP3Red: components[0], green: components[1], blue: components[2], alpha: components[3])
        } else {
            return UIColor(displayP3Red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        }
    }
    
    // Color -> RGB
    func toRGB() -> (red: CGFloat, green: CGFloat, blue: CGFloat) {
        if let components = self.cgColor?.components {
            return (red: components[0], green: components[1], blue: components[2])
        } else {
            return (red: 0.0, green: 0.0, blue: 0.0)
        }
    }
    // Color -> color code
    func toColorCode() -> String {
        if let components = self.cgColor?.components {
            let rgb: [CGFloat] = [components[0], components[1], components[2]]
            return rgb.reduce("") { res, value in
                let intval = Int(round(value * 255))
                return res + (NSString(format: "%02X", intval) as String)
            }
        } else {
            return ""
        }
    }
    // Color(hex: color code)
    init(hex: String) {
        let v = Int("000000" + hex, radix: 16) ?? 0
        let r = CGFloat(v / Int(powf(256, 2)) % 256) / 255
        let g = CGFloat(v / Int(powf(256, 1)) % 256) / 255
        let b = CGFloat(v / Int(powf(256, 0)) % 256) / 255
        self.init(red: r, green: g, blue: b)
    }
}

// Color -> UIColor
Color.white.toUIColor()

// Color -> RGB
Color.white.toRGB()

// Color -> color code
Color.white.toColorCode()

// Color(hex: color code)
Color(hex: "FFFFF")

