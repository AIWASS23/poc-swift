import Foundation

class SymbolLoader {
    
    static func loadSymbolsFromSystem() -> [String] {
        var symbols = [String]()
        if let bundle = Bundle(identifier: "com.apple.CoreGlyphs"),
           let resourcePath = bundle.path(forResource: "name_availability", ofType: "plist"),
           let plist = NSDictionary(contentsOfFile: resourcePath),
           let plistSymbols = plist["symbols"] as? [String: String] {
            symbols = Array(plistSymbols.keys)
        }
        return symbols
    }
}