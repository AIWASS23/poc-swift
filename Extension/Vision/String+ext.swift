import Foundation

extension String {
    subscript(idx: Int) -> String {
        String(self[index(startIndex, offsetBy: idx)])
    }
    func pad(_ len: Int) -> String {
        padding(toLength: len, withPad: " ", startingAt: 0)
    }
    static func pointer(_ object: AnyObject?) -> String {
        guard let object = object else { return "nil" }
        let opaque: UnsafeMutableRawPointer = Unmanaged.passUnretained(object).toOpaque()
        return String(describing: opaque)
    }
}
func superScript(_ num: Int) -> String {
    var s = ""
    let numStr = String(num)
    for n in numStr.utf8 {
        let i = Int(n) - 48 // utf8 for '0'
        s += "⁰¹²³⁴⁵⁶⁷⁸⁹"[i]
    }
    return s
}
