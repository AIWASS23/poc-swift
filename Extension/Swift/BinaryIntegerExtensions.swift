import Foundation

extension BinaryInteger {
    // The raw bytes of the integer.
    
    var bytes: [UInt8] {
        var result = [UInt8]()
        result.reserveCapacity(MemoryLayout<Self>.size)
        var value = self
        for _ in 0..<MemoryLayout<Self>.size {
            result.append(UInt8(truncatingIfNeeded: value))
            value >>= 8
        }
        return result.reversed()
    }
}

extension BinaryInteger {
    // Creates a `BinaryInteger` from a raw byte representation.
    
    init?(bytes: [UInt8]) {
        precondition(
            bytes.count <= MemoryLayout<Self>.size,
            "Integer with a \(bytes.count) byte binary representation of '\(bytes.map { String($0, radix: 2) }.joined(separator: " "))' overflows when stored into a \(MemoryLayout<Self>.size) byte '\(Self.self)'")
        var value: Self = 0
        for byte in bytes {
            value <<= 8
            value |= Self(byte)
        }
        self.init(exactly: value)
    }
}
