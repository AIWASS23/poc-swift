import Foundation
import SwiftUI

extension Color {
    
    static func ~= ( left: inout Color, right: String) {
        left = right.color!
    }
    
    init?(fromHex hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0
        
        let length = hexSanitized.count
        
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
        
        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
            
        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
            
        } else {
            return nil
        }
        
        self.init(
            RGBColorSpace.sRGBLinear, 
            red: Double(r), 
            green: Double(g), 
            blue: Double(b), 
            opacity: Double(a)
        )
    }
    
    init(fromGrayScaleShade shade:Int, withAlphaPercent alphaPercent: Int = 100) {
        let value = CGFloat(shade) / 255.0
        let alphaValue = CGFloat(alphaPercent) / 100.0
        self.init(RGBColorSpace.sRGB, red: Double(value), green: Double(value), blue: Double(value), opacity: Double(alphaValue))
    }
    
    init(red: Int, green: Int, blue: Int, alpha: Int = 100) {
        let r = CGFloat(red) / 255.0
        let g = CGFloat(green) / 255.0
        let b = CGFloat(blue) / 255.0
        let a = CGFloat(alpha) / 100.0
        
        self.init(RGBColorSpace.sRGB, red: Double(r), green: Double(g), blue: Double(b), opacity: Double(a))
    }
    
    init (fromRGBA rgbComponents: (red: Int, green: Int, blue: Int, alpha: Int)) {
        let r = CGFloat(rgbComponents.red) / 255.0
        let g = CGFloat(rgbComponents.green) / 255.0
        let b = CGFloat(rgbComponents.blue) / 255.0
        let a = CGFloat(rgbComponents.alpha) / 100.0
        
        self.init(RGBColorSpace.sRGB, red: Double(r), green: Double(g), blue: Double(b), opacity: Double(a))
    }
    
    init (hue: Int, saturation: Int, brightness: Int, alpha: Int = 100) {
        let h = CGFloat(hue) / 360.0
        let s = CGFloat(saturation) / 100.0
        let b = CGFloat(brightness) / 100.0
        let a = CGFloat(alpha) / 100.0
        
        self.init(hue: Double(h), saturation: Double(s), brightness: Double(b), opacity: Double(a))
    }

    init(fromHSBA hsbComponents: (hue: Int, saturation: Int, brightness: Int, alpha: Int)) {
        let h = CGFloat(hsbComponents.hue) / 360.0
        let s = CGFloat(hsbComponents.saturation) / 100.0
        let b = CGFloat(hsbComponents.brightness) / 100.0
        let a = CGFloat(hsbComponents.alpha) / 100.0
        
        self.init(hue: Double(h), saturation: Double(s), brightness: Double(b), opacity: Double(a))
    }
    
    static var colorScheme: ColorScheme = .light
    
    static var systemGray: Color {
        
        switch colorScheme {
        case .dark:
            return Color(fromHex: "8E8E93FF")!
        default:
            return Color(fromHex: "8E8E93FF")!
        }
    }
    
    static var systemGray2: Color {
        
        switch colorScheme {
        case .dark:
            return Color(fromHex: "636366FF")!
        default:
            return Color(fromHex: "AEAEB2FF")!
        }
        
    }
    
    static var systemGray3:Color {
        
        switch colorScheme {
        case .dark:
            return Color(fromHex: "48484AFF")!
        default:
            return Color(fromHex: "C7C7CCFF")!
        }
    }
    
    static var systemGray4:Color {
        
        switch colorScheme {
        case .dark:
            return Color(fromHex: "3A3A3CFF")!
        default:
            return Color(fromHex: "D1D1D6FF")!
        }
    }
    
    
    static var systemGray5: Color {
        
        switch colorScheme {
        case .dark:
            return Color(fromHex: "2C2C2EFF")!
        default:
            return Color(fromHex: "E5E5EAFF")!
        }
    }
    
    static var systemGray6:Color {
        
        switch colorScheme {
        case .dark:
            return Color(fromHex: "1C1C1EFF")!
        default:
            return Color(fromHex: "F2F2F7FF")!
        }
    }
    
    var baseComponents: (red: Float, green: Float, blue: Float, alpha: Float) {
        var (red, green, blue, alpha) = (Float(0.0), Float(0.0), Float(0.0), Float(0.0))
        
        guard let components = cgColor?.components, components.count >= 3 else {
            // Default to black
            return (red, green, blue, alpha)
        }
        
        red = Float(components[0])
        green = Float(components[1])
        blue = Float(components[2])
        alpha = Float(1.0)
        
        if components.count >= 4 {
            alpha = Float(components[3])
        }
        
        return (red, green, blue, alpha)
    }
    
    var rgbComponents: (red: Int, green: Int, blue: Int, alpha: Int) {
        get {
            let (red, green, blue, alpha) = self.baseComponents
            
            let r = round(red * Float(255.0))
            let g = round(green * Float(255.0))
            let b = round(blue * Float(255.0))
            let a = round(alpha * Float(100.0))
            
            return (red: Int(r), green: Int(g), blue: Int(b), alpha: Int(a))
        }
    }
    
    var alphaValue: Int {
        get {return rgbComponents.alpha}
    }
    
    
    var redValue: Int {
        get {return rgbComponents.red}
    }
    
    var greenValue: Int {
        get {return rgbComponents.green}
    }
    
    
    var blueValue: Int {
        get {return rgbComponents.blue}
    }
    
    var hsbComponents: (hue: Int, saturation: Int, brightness: Int, alpha: Int) {
        get {
            let (red, green, blue, alpha) = self.baseComponents
            
            let cmin = min(red, green, blue)
            let cmax = max(red, green, blue)
            let delta = cmax - cmin
            
            var h = Float(0.0)
            var s = Float(0.0)
            var l = Float(0.0)
            
            // Calculate color
            if delta == Float(0.0) {
                h = Float(0.0)
            } else if (cmax == red) {
                h = ((green - blue) / delta).truncatingRemainder(dividingBy: Float(6.0))
            } else if (cmax == green) {
                h = (blue - red) / delta + Float(2.0)
            } else {
                h = (red - green) / delta + Float(4.0)
            }
            
            // Make negative hues positive behind 360°
            if h < 0 {
                h += Float(360.0)
            }
            
            // Calculate lightness
            l = (cmax + cmin) / Float(2.0)
            
            // Calculate saturation
            s = (delta == Float(0.0)) ? Float(0.0) : delta / (Float(1.0) - abs(Float(2.0) * l - Float(1.0)))
            
            // Multiply l and s by 100
            s = +(s * Float(100.0))
            l = +(l * Float(100.0))
            
            // Cleanup
            h = round(h)
            s = round(s)
            l = round(l)
            let a = round(alpha * Float(100.0))
            
            return (hue: Int(h), saturation: Int(s), brightness: Int(l), alpha: Int(a))
        }
    }
    
    var hueValue: Int {
        get { return hsbComponents.hue}
    }
    
    var saturationValue: Int {
        get {return hsbComponents.saturation}
    }
    
    var brightnessValue: Int {
        get {return hsbComponents.brightness}
    }
    
    var grayScaleComponents: (shade: Int, alpha: Int) {
        get {
            let (red, _, _, alpha) = self.baseComponents
            
            let r = round(red * Float(255.0))
            let a = round(alpha * Float(100.0))
            
            return (shade: Int(r), alpha: Int(a))
        }
    }
    
    var shadeValue: Int {
        get { return grayScaleComponents.shade}
    }
    
    /// Returns `true` if the color is bright, else returns `false`.
    var isBrightColor: Bool {
        let (red, green, blue, _) = self.baseComponents
        
        let r = CGFloat(red)
        let g = CGFloat(green)
        let b = CGFloat(blue)
        var brightness: CGFloat = 0.0
        
        brightness = ((r * 299) + (g * 587) + (b * 114)) / 1000;
        if (brightness < 0.5) {
            return false
        }
        else {
            return true
        }
    }
    
    func toHex(withPrefix hash: Bool = true, includeAlpha alpha: Bool = true) -> String {
        let prefix = hash ? "#" : ""
        
        guard let components = cgColor?.components, components.count >= 3 else {
            // Default to white
            return prefix + "FFFFFF"
        }
        
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)
        
        if components.count >= 4 {
            a = Float(components[3])
        }
        
        if alpha {
            return prefix + String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255.0), lroundf(g * 255.0), lroundf(b * 255.0), lroundf(a * 255.0))
        } else {
            return prefix + String(format: "%02lX%02lX%02lX", lroundf(r * 255.0), lroundf(g * 255.0), lroundf(b * 255.0))
        }
    }
    
    func withAlphaValue(_ alpha: Int) -> Color {
        var components = rgbComponents
        components.alpha = alpha
        return Color(fromRGBA: components)
    }
    
    func withRedValue(_ red: Int) -> Color {
        var components = rgbComponents
        components.red = red
        return Color(fromRGBA: components)
    }
    
    func withGreenValue(_ green: Int) -> Color {
        var components = rgbComponents
        components.green = green
        return Color(fromRGBA: components)
    }
    
    func withBlueValue(_ blue: Int) -> Color {
        var components = rgbComponents
        components.blue = blue
        return Color(fromRGBA: components)
    }
    
    func withHueValue(_ hue: Int) -> Color {
        var components = hsbComponents
        components.hue = hue
        return Color(fromHSBA: components)
    }
    
    func withSaturationValue(_ saturation: Int) -> Color {
        var components = hsbComponents
        components.saturation = saturation
        return Color(fromHSBA: components)
    }
    
    func withBrightnessValue(_ brightness: Int) -> Color {
        var components = hsbComponents
        components.brightness = brightness
        return Color(fromHSBA: components)
    }
    
    func contrastingColor(lightColor:Color = Color.white, darkColor:Color = Color.black) -> Color {
        let (red, green, blue, _) = self.baseComponents
        
        let r = CGFloat(red)
        let g = CGFloat(green)
        let b = CGFloat(blue)
        var brightness: CGFloat = 0.0
        
        brightness = ((r * 299) + (g * 587) + (b * 114)) / 1000;
        if (brightness < 0.5) {
            return lightColor
        }
        else {
            return darkColor
        }
    }
}
