import Foundation
import AppKit

extension String {
   
    var base64Decoded: String? {
        if let data = Data(base64Encoded: self,
                           options: .ignoreUnknownCharacters) {
            return String(data: data, encoding: .utf8)
        }

        let remainder = count % 4

        var padding = ""
        if remainder > 0 {
            padding = String(repeating: "=", count: 4 - remainder)
        }

        guard let data = Data(base64Encoded: self + padding,
                              options: .ignoreUnknownCharacters) else { return nil }

        return String(data: data, encoding: .utf8)
    }
   
    var base64Encoded: String? {
        let plainData = data(using: .utf8)
        return plainData?.base64EncodedString()
    }
   
    var charactersArray: [Character] {
        return Array(self)
    }

    var camelCased: String {
        let source = lowercased()
        let first = source[..<source.index(after: source.startIndex)]
        if source.contains(" ") {
            let connected = source.capitalized.replacingOccurrences(of: " ", with: "")
            let camel = connected.replacingOccurrences(of: "\n", with: "")
            let rest = String(camel.dropFirst())
            return first + rest
        }
        let rest = String(source.dropFirst())
        return first + rest
    }
   
    var containEmoji: Bool {
        for scalar in unicodeScalars {
            switch scalar.value {
            case 0x1F600...0x1F64F, // Emoticons
                 0x1F300...0x1F5FF, // Misc Symbols and Pictographs
                 0x1F680...0x1F6FF, // Transport and Map
                 0x1F1E6...0x1F1FF, // Regional country flags
                 0x2600...0x26FF, // Misc symbols
                 0x2700...0x27BF, // Dingbats
                 0xE0020...0xE007F, // Tags
                 0xFE00...0xFE0F, // Variation Selectors
                 0x1F900...0x1F9FF, // Supplemental Symbols and Pictographs
                 127_000...127_600, // Various asian characters
                 65024...65039, // Variation selector
                 9100...9300, // Misc items
                 8400...8447: // Combining Diacritical Marks for Symbols
                return true
            default:
                continue
            }
        }
        return false
    }

    
    var firstCharacterAsString: String? {
        guard let first = first else { return nil }
        return String(first)
    }

    var hasLetters: Bool {
        return rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
    }

    var hasNumbers: Bool {
        return rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
    }

    var isAlphabetic: Bool {
        let hasLetters = rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
        let hasNumbers = rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
        return hasLetters && !hasNumbers
    }

    
    var isAlphaNumeric: Bool {
        let hasLetters = rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
        let hasNumbers = rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
        let comps = components(separatedBy: .alphanumerics)
        return comps.joined(separator: "").count == 0 && hasLetters && hasNumbers
    }

    
    var isPalindrome: Bool {
        let letters = filter(\.isLetter)
        guard !letters.isEmpty else { return false }
        let midIndex = letters.index(letters.startIndex, offsetBy: letters.count / 2)
        let firstHalf = letters[letters.startIndex..<midIndex]
        let secondHalf = letters[midIndex..<letters.endIndex].reversed()
        return !zip(firstHalf, secondHalf).contains(where: { $0.lowercased() != $1.lowercased() })
    }

    
    var isValidEmail: Bool {
        // http://emailregex.com/
        let regex =
            "^(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])$"
        return range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
   
    var isValidUrl: Bool {
        return URL(string: self) != nil
    }
   
    var isValidSchemedUrl: Bool {
        guard let url = URL(string: self) else { return false }
        return url.scheme != nil
    }
    
   
    var isValidHttpsUrl: Bool {
        guard let url = URL(string: self) else { return false }
        return url.scheme == "https"
    }
  
    var isValidHttpUrl: Bool {
        guard let url = URL(string: self) else { return false }
        return url.scheme == "http"
    }
   
    var isValidFileUrl: Bool {
        return URL(string: self)?.isFileURL ?? false
    }
   
    var isNumeric: Bool {
        let scanner = Scanner(string: self)
        scanner.locale = NSLocale.current
        #if os(Linux) || targetEnvironment(macCatalyst)
        return scanner.scanDecimal() != nil && scanner.isAtEnd
        #else
        return scanner.scanDecimal(nil) && scanner.isAtEnd
        #endif
    }
   
    var isDigits: Bool {
        return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: self))
    }
    
    var lastCharacterAsString: String? {
        guard let last = last else { return nil }
        return String(last)
    }

    
    var latinized: String {
        return folding(options: .diacriticInsensitive, locale: Locale.current)
    }
   
    var bool: Bool? {
        let selfLowercased = trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        switch selfLowercased {
        case "true", "yes", "1":
            return true
        case "false", "no", "0":
            return false
        default:
            return nil
        }
    }
   
    var date: Date? {
        let selfLowercased = trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: selfLowercased)
    }
   
    var dateTime: Date? {
        let selfLowercased = trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.date(from: selfLowercased)
    }
  
    var int: Int? {
        return Int(self)
    }

   
    static func loremIpsum(ofLength length: Int = 445) -> String {
        guard length > 0 else { return "" }

        // https://www.lipsum.com/
        let loremIpsum = """
        Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
        """
        if loremIpsum.count > length {
            return String(loremIpsum[loremIpsum.startIndex..<loremIpsum.index(loremIpsum.startIndex, offsetBy: length)])
        }
        return loremIpsum
    }

    var url: URL? {
        return URL(string: self)
    }
   
    var trimmed: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
   
    var urlDecoded: String {
        return removingPercentEncoding ?? self
    }
   
    var urlEncoded: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var regexEscaped: String {
        return NSRegularExpression.escapedPattern(for: self)
    }
   
    var withoutSpacesAndNewLines: String {
        return replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "")
    }
    var isWhitespace: Bool {
        return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}



extension String {
   
    func float(locale: Locale = .current) -> Float? {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.allowsFloats = true
        return formatter.number(from: self)?.floatValue
    }
    
    func double(locale: Locale = .current) -> Double? {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.allowsFloats = true
        return formatter.number(from: self)?.doubleValue
    }
   
    func cgFloat(locale: Locale = .current) -> CGFloat? {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.allowsFloats = true
        return formatter.number(from: self) as? CGFloat
    }
   
    func lines() -> [String] {
        var result = [String]()
        enumerateLines { line, _ in
            result.append(line)
        }
        return result
    }
  
    func localized(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
   
    func formatLocalized(comment: String = "", _ arguments: (any CVarArg)...) -> String {
        let format = NSLocalizedString(self, comment: comment)
        return String(format: format, arguments: arguments)
    }
   
    func mostCommonCharacter() -> Character? {
        let mostCommon = withoutSpacesAndNewLines.reduce(into: [Character: Int]()) {
            let count = $0[$1] ?? 0
            $0[$1] = count + 1
        }.max { $0.1 < $1.1 }?.key

        return mostCommon
    }

   
    func unicodeArray() -> [Int] {
        return unicodeScalars.map { Int($0.value) }
    }

   
    func words() -> [String] {
        let characterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
        let comps = components(separatedBy: characterSet)
        return comps.filter { !$0.isEmpty }
    }
   
    func wordCount() -> Int {
        let characterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
        let comps = components(separatedBy: characterSet)
        let words = comps.filter { !$0.isEmpty }
        return words.count
    }
   
    func toSlug() -> String {
        let lowercased = self.lowercased()
        let latinized = lowercased.folding(options: .diacriticInsensitive, locale: Locale.current)
        let withDashes = latinized.replacingOccurrences(of: " ", with: "-")

        let alphanumerics = NSCharacterSet.alphanumerics
        var filtered = withDashes.filter {
            guard String($0) != "-" else { return true }
            guard String($0) != "&" else { return true }
            return String($0).rangeOfCharacter(from: alphanumerics) != nil
        }

        while filtered.lastCharacterAsString == "-" {
            filtered = String(filtered.dropLast())
        }

        while filtered.firstCharacterAsString == "-" {
            filtered = String(filtered.dropFirst())
        }

        return filtered.replacingOccurrences(of: "--", with: "-")
    }
   
    subscript(safe index: Int) -> Character? {
        guard index >= 0, index < count else { return nil }
        return self[self.index(startIndex, offsetBy: index)]
    }

   
    subscript(safe range: Range<Int>) -> String? {
        guard range.lowerBound >= 0,
              range.upperBound <= count else {
            return nil
        }

        return String(self[range])
    }

    subscript(safe range: ClosedRange<Int>) -> String? {
        guard range.lowerBound >= 0,
              range.upperBound < count else {
            return nil
        }

        return String(self[range])
    }

   
    subscript(safe range: PartialRangeUpTo<Int>) -> String? {
        guard range.upperBound >= 0,
              range.upperBound <= count else {
            return nil
        }

        return String(self[range])
    }

    
    subscript(safe range: PartialRangeThrough<Int>) -> String? {
        guard range.upperBound >= 0,
              range.upperBound < count else {
            return nil
        }

        return String(self[range])
    }

    
    subscript(safe range: PartialRangeFrom<Int>) -> String? {
        guard range.lowerBound >= 0,
              range.lowerBound < count else {
            return nil
        }

        return String(self[range])
    }

   
    func copyToPasteboard() {
        #if os(iOS)
        UIPasteboard.general.string = self
        #elseif os(macOS)
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(self, forType: .string)
        #endif
    }
   
    @discardableResult
    mutating func camelize() -> String {
        let source = lowercased()
        let first = source[..<source.index(after: source.startIndex)]
        if source.contains(" ") {
            let connected = source.capitalized.replacingOccurrences(of: " ", with: "")
            let camel = connected.replacingOccurrences(of: "\n", with: "")
            let rest = String(camel.dropFirst())
            self = first + rest
            return self
        }
        let rest = String(source.dropFirst())

        self = first + rest
        return self
    }

    
    mutating func firstCharacterUppercased() {
        guard let first = first else { return }
        self = String(first).uppercased() + dropFirst()
    }

    
    func hasUniqueCharacters() -> Bool {
        guard count > 0 else { return false }
        var uniqueChars = Set<String>()
        for char in self {
            if uniqueChars.contains(String(char)) { return false }
            uniqueChars.insert(String(char))
        }
        return true
    }

    
    func contains(_ string: String, caseSensitive: Bool = true) -> Bool {
        if !caseSensitive {
            return range(of: string, options: .caseInsensitive) != nil
        }
        return range(of: string) != nil
    }
    
    func count(of string: String, caseSensitive: Bool = true) -> Int {
        if !caseSensitive {
            return lowercased().components(separatedBy: string.lowercased()).count - 1
        }
        return components(separatedBy: string).count - 1
    }
   
    func ends(with suffix: String, caseSensitive: Bool = true) -> Bool {
        if !caseSensitive {
            return lowercased().hasSuffix(suffix.lowercased())
        }
        return hasSuffix(suffix)
    }

   
    @discardableResult
    mutating func latinize() -> String {
        self = folding(options: .diacriticInsensitive, locale: Locale.current)
        return self
    }
    
    static func random(ofLength length: Int) -> String {
        guard length > 0 else { return "" }
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString = ""
        for _ in 1...length {
            randomString.append(base.randomElement()!)
        }
        return randomString
    }

    
    @discardableResult
    mutating func reverse() -> String {
        let chars: [Character] = reversed()
        self = String(chars)
        return self
    }

    
    func slicing(from index: Int, length: Int) -> String? {
        guard length >= 0, index >= 0, index < count else { return nil }
        guard index.advanced(by: length) <= count else {
            return self[safe: index..<count]
        }
        guard length > 0 else { return "" }
        return self[safe: index..<index.advanced(by: length)]
    }

    @discardableResult
    mutating func slice(from index: Int, length: Int) -> String {
        if let str = slicing(from: index, length: length) {
            self = String(str)
        }
        return self
    }
 
    @discardableResult
    mutating func slice(from start: Int, to end: Int) -> String {
        guard end >= start else { return self }
        if let str = self[safe: start..<end] {
            self = str
        }
        return self
    }

    @discardableResult
    mutating func slice(at index: Int) -> String {
        guard index < count else { return self }
        if let str = self[safe: index..<count] {
            self = str
        }
        return self
    }

    func starts(with prefix: String, caseSensitive: Bool = true) -> Bool {
        if !caseSensitive {
            return lowercased().hasPrefix(prefix.lowercased())
        }
        return hasPrefix(prefix)
    }

   
    func date(withFormat format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
   
    @discardableResult
    mutating func trim() -> String {
        self = trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return self
    }
   
    @discardableResult
    mutating func truncate(toLength length: Int, trailing: String? = "...") -> String {
        guard length > 0 else { return self }
        if count > length {
            self = self[startIndex..<index(startIndex, offsetBy: length)] + (trailing ?? "")
        }
        return self
    }

    func truncated(toLength length: Int, trailing: String? = "...") -> String {
        guard 0..<count ~= length else { return self }
        return self[startIndex..<index(startIndex, offsetBy: length)] + (trailing ?? "")
    }

    @discardableResult
    mutating func urlDecode() -> String {
        if let decoded = removingPercentEncoding {
            self = decoded
        }
        return self
    }
   
    @discardableResult
    mutating func urlEncode() -> String {
        if let encoded = addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
            self = encoded
        }
        return self
    }
   
    func matches(pattern: String) -> Bool {
        return range(of: pattern, options: .regularExpression, range: nil, locale: nil) != nil
    }
   
    func matches(regex: NSRegularExpression, options: NSRegularExpression.MatchingOptions = []) -> Bool {
        let range = NSRange(startIndex..<endIndex, in: self)
        return regex.firstMatch(in: self, options: options, range: range) != nil
    }
   
    static func ~= (lhs: String, rhs: String) -> Bool {
        return rhs.range(of: lhs, options: .regularExpression) != nil
    }
   
    static func ~= (lhs: NSRegularExpression, rhs: String) -> Bool {
        let range = NSRange(rhs.startIndex..<rhs.endIndex, in: rhs)
        return lhs.firstMatch(in: rhs, range: range) != nil
    }
    
    func replacingOccurrences(
        of regex: NSRegularExpression,
        with template: String,
        options: NSRegularExpression.MatchingOptions = [],
        range searchRange: Range<String.Index>? = nil) -> String {
        let range = NSRange(searchRange ?? startIndex..<endIndex, in: self)
        return regex.stringByReplacingMatches(in: self, options: options, range: range, withTemplate: template)
    }
    
    @discardableResult
    mutating func padStart(_ length: Int, with string: String = " ") -> String {
        self = paddingStart(length, with: string)
        return self
    }

    
    func paddingStart(_ length: Int, with string: String = " ") -> String {
        guard count < length else { return self }

        let padLength = length - count
        if padLength < string.count {
            return string[string.startIndex..<string.index(string.startIndex, offsetBy: padLength)] + self
        } else {
            var padding = string
            while padding.count < padLength {
                padding.append(string)
            }
            return padding[padding.startIndex..<padding.index(padding.startIndex, offsetBy: padLength)] + self
        }
    }

    @discardableResult
    mutating func padEnd(_ length: Int, with string: String = " ") -> String {
        self = paddingEnd(length, with: string)
        return self
    }

    func paddingEnd(_ length: Int, with string: String = " ") -> String {
        guard count < length else { return self }

        let padLength = length - count
        if padLength < string.count {
            return self + string[string.startIndex..<string.index(string.startIndex, offsetBy: padLength)]
        } else {
            var padding = string
            while padding.count < padLength {
                padding.append(string)
            }
            return self + padding[padding.startIndex..<padding.index(padding.startIndex, offsetBy: padLength)]
        }
    }

    
    func removingPrefix(_ prefix: String) -> String {
        guard hasPrefix(prefix) else { return self }
        return String(dropFirst(prefix.count))
    }

    func removingSuffix(_ suffix: String) -> String {
        guard hasSuffix(suffix) else { return self }
        return String(dropLast(suffix.count))
    }

    
    func withPrefix(_ prefix: String) -> String {
        guard !hasPrefix(prefix) else { return self }
        return prefix + self
    }
}


extension String {

    init?(base64: String) {
        guard let decodedData = Data(base64Encoded: base64) else { return nil }
        guard let str = String(data: decodedData, encoding: .utf8) else { return nil }
        self.init(str)
    }
   
}

extension String {
    
    static func * (lhs: String, rhs: Int) -> String {
        guard rhs > 0 else { return "" }
        return String(repeating: lhs, count: rhs)
    }

    
    static func * (lhs: Int, rhs: String) -> String {
        guard lhs > 0 else { return "" }
        return String(repeating: rhs, count: lhs)
    }
}

extension String {
    var nsString: NSString {
        return NSString(string: self)
    }

    var fullNSRange: NSRange { NSRange(startIndex..<endIndex, in: self) }

    var lastPathComponent: String {
        return (self as NSString).lastPathComponent
    }

    var pathExtension: String {
        return (self as NSString).pathExtension
    }

    var deletingLastPathComponent: String {
        return (self as NSString).deletingLastPathComponent
    }

    var deletingPathExtension: String {
        return (self as NSString).deletingPathExtension
    }

    var pathComponents: [String] {
        return (self as NSString).pathComponents
    }

    func range(from nsRange: NSRange) -> Range<Index> {
        guard let range = Range(nsRange, in: self) else { fatalError("Failed to find range \(nsRange) in \(self)") }
        return range
    }

    func nsRange(from range: Range<Index>) -> NSRange {
        return NSRange(range, in: self)
    }

    func appendingPathComponent(_ str: String) -> String {
        return (self as NSString).appendingPathComponent(str)
    }

    func appendingPathExtension(_ str: String) -> String? {
        return (self as NSString).appendingPathExtension(str)
    }

    subscript(bounds: NSRange) -> Substring {
        guard let range = Range(bounds, in: self) else { fatalError("Failed to find range \(bounds) in \(self)") }
        return self[range]
    }
}