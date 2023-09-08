import Foundation

extension NSColor {
    
    // NSColor -> Color
    func toColor() -> Color {
        if let components = self.cgColor.components {
            return Color(red: components[0], green: components[1], blue: components[2], opacity: components[3])
        } else {
            return Color(red: 0.0, green: 0.0, blue: 0.0, opacity: 0.0)
        }
    }
    
    // NSColor -> RGB
    func toRGB() -> (displayP3Red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        if let components = self.cgColor.components {
            return (displayP3Red: components[0], green: components[1], blue: components[2], alpha: components[3])
        } else {
            return (displayP3Red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        }
    }
    
    // NSColor -> color code
    func toColorCode() -> String {
        if let components = self.cgColor.components {
            let rgb: [CGFloat] = [components[0], components[1], components[2]]
            return rgb.reduce("") { res, value in
                let intval = Int(round(value * 255))
                return res + (NSString(format: "%02X", intval) as String)
            }
        } else {
            return ""
        }
    }
    
    // NSColor(hex: color code, alpha: CGFloat)
    convenience init(hex: String, alpha: CGFloat) {
        let v = Int("000000" + hex, radix: 16) ?? 0
        let r = CGFloat(v / Int(powf(256, 2)) % 256) / 255
        let g = CGFloat(v / Int(powf(256, 1)) % 256) / 255
        let b = CGFloat(v / Int(powf(256, 0)) % 256) / 255
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}

// NSColor -> Color
NSColor.white.toColor()

// NSColor -> RGB
NSColor.white.toRGB()

// NSColor -> color code
NSColor.white.toColorCode()

// NSColor(hex: color code, alpha: CGFloat)
NSColor(hex: "FFFFFF", alpha: 1.0)

