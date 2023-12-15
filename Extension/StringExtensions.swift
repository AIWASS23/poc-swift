import Foundation
import SwiftUI

extension String {
    
    enum TruncationPosition {
        case head
        case middle
        case tail
    }
    
    enum TrimmingOptions {
        case all
        case leading
        case trailing
        case leadingAndTrailing
    }
    
    static func ~= ( left: inout String, right: Color) {
        left = right.toHex()
    }
    
    static func === ( left: String, right: String) -> Bool  {
        return left.compare(right, options: .caseInsensitive) == .orderedSame
    }
    
    
    var color: Color? {
        return Color(fromHex: self)
    }
    
    init(fromColor color: Color) {
        self = color.toHex()
    }
    
    static func typeName(of value: Any) -> String {
        // Use a mirror to get the type name
        let mirror = Mirror(reflecting: value)
        var name = "\(mirror.subjectType)"
        
        // Clean up dictionary names
        name = name.replacingOccurrences(of: "<", with: "(")
        name = name.replacingOccurrences(of: ">", with: ")")
        
        // Remove the module name if included
        if name.contains(".") {
            let parts = name.components(separatedBy: ".")
            return parts[parts.count-1]
        } else {
            return name
        }
    }
    
    func height(withConstrainedWidth width: CGFloat, font: Font) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: Font) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    func bounds(withConstrainedSize size: CGSize, font: Font) -> CGSize {
        let boundingBox = self.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return CGSize(width: boundingBox.width, height: boundingBox.height)
    }
    
    func truncated(limit: Int, position: TruncationPosition = .tail, leader: String = "...") -> String {
        guard self.count > limit else { return self }
        
        switch position {
        case .head:
            return leader + self.suffix(limit)
        case .middle:
            let headCharactersCount = Int(ceil(Float(limit - leader.count) / 2.0))
            
            let tailCharactersCount = Int(floor(Float(limit - leader.count) / 2.0))
            
            return "\(self.prefix(headCharactersCount))\(leader)\(self.suffix(tailCharactersCount))"
        case .tail:
            return self.prefix(limit) + leader
        }
    }
    
    var htmlDecoded: String {
        let decoded = try? NSAttributedString(data: Data(utf8), options: [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
            ], documentAttributes: nil).string
        
        return decoded ?? self
    }
    
    mutating func concat(_ value:String, separator:String = ",") {
        if self == "" {
            self = value
        } else {
            self = "\(self)\(separator)\(value)"
        }
    }
    
    func trimming(spaces: TrimmingOptions, using characterSet: CharacterSet = .whitespacesAndNewlines) ->  String {
        switch spaces {
        case .all: return trimmingAllSpaces(using: characterSet)
        case .leading: return trimingLeadingSpaces(using: characterSet)
        case .trailing: return trimingTrailingSpaces(using: characterSet)
        case .leadingAndTrailing:  return trimmingLeadingAndTrailingSpaces(using: characterSet)
        }
    }
    
    private func trimingLeadingSpaces(using characterSet: CharacterSet) -> String {
        guard let index = firstIndex(where: { !CharacterSet(charactersIn: String($0)).isSubset(of: characterSet) }) else {
            return self
        }

        return String(self[index...])
    }
    
    private func trimingTrailingSpaces(using characterSet: CharacterSet) -> String {
        guard let index = lastIndex(where: { !CharacterSet(charactersIn: String($0)).isSubset(of: characterSet) }) else {
            return self
        }

        return String(self[...index])
    }
    
    private func trimmingLeadingAndTrailingSpaces(using characterSet: CharacterSet) -> String {
        return trimmingCharacters(in: characterSet)
    }
    
    private func trimmingAllSpaces(using characterSet: CharacterSet) -> String {
        return components(separatedBy: characterSet).joined()
    }
    
    func base64Encoded() -> String {
        if let value = data(using: .utf8)?.base64EncodedString() {
            return value
        } else {
            return ""
        }
    }
    
    func base64Decoded() -> String {
        guard let data = Data(base64Encoded: self) else { return "" }
        
        if let value = String(data: data, encoding: .utf8) {
            return value
        } else {
            return ""
        }
    }
    
    
    func hasPattern(_ inputPattern:String, partialMatch:Bool = true) -> Bool {
        var text = self.lowercased()
        var pattern = inputPattern.lowercased()
        
        // Are we doing a simple one-to-one compare?
        guard partialMatch else {
            return (text == pattern)
        }
        
        // Pad both entries to ensure we get the correct match types
        text = " \(text) "
        pattern = " \(pattern) "
        
        // Does the text contain the pattern?
        return text.contains(pattern)
    }
    
    func randomPart() -> String {
        
        guard self.contains("|") else {
            return self
        }
        
        let parts = self.components(separatedBy: "|")
        
        let max:Int = parts.count - 1
        let index = Int.random(in: 0...max)
        
        return parts[index]
    }

    func titlecased() -> String {
    if self.count <= 1 {
      return self.uppercased()
    }

    let regex = try! NSRegularExpression(pattern: "(?=\\S)[A-Z]", options: [])
    let range = NSMakeRange(1, self.count - 1)
    var titlecased = regex.stringByReplacingMatches(in: self, range: range, withTemplate: " $0")

    for i in titlecased.indices {
      if i == titlecased.startIndex || titlecased[titlecased.index(before: i)] == " " {
        titlecased.replaceSubrange(i...i, with: String(titlecased[i]).uppercased())
      }
    }
    return titlecased
  }
}

extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}
