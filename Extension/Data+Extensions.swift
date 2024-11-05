//
//  Data+Extensions.swift
//
//
//  Created by Marcelo de Araújo
//

import CryptoKit
import Foundation

extension Data {

    static let minMmapByteSize = 1024 * 1000 * 8

    var sha256Hash: String {
        let hashed = SHA256.hash(data: self)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }

    var bytes: [UInt8] {
        [UInt8](self)
    }

    var byteCountFormatted: String {
        let bcf = ByteCountFormatter()
        bcf.allowedUnits = [.useMB]
        bcf.countStyle = .file
        let string = bcf.string(fromByteCount: Int64(count))
        return string
    }

    func unsafeType<T>() -> T? {
        guard let result: UnsafePointer<T> = unsafePointer() else { return nil }
        return result.pointee
    }

    func unsafeTypeArray<T>(_ count: Int? = nil) -> [T] {
        let count = count ?? Int(self.count / MemoryLayout<T>.size)
        return withUnsafeBytes { (pointer) -> [T] in
            let buffer = UnsafeBufferPointer(start: pointer.baseAddress?.assumingMemoryBound(to: T.self), count: count)
            return Array(buffer)
        }
    }

    func toUnsafeBufferPointer<T>() -> UnsafeBufferPointer<T> {
        withUnsafeBytes { (pointer) -> UnsafeBufferPointer<T> in
            pointer.assumingMemoryBound(to: T.self)
        }
    }

    func slice(offset: Int, count: Int? = nil) -> Data {
        let end = count ?? bytes.count
        let range = offset..<end
        return self[range]
    }

    func mmap(_ fileName: String) -> Data? {
        let cacheDir = FileManager.default.cacheDirectory
        let cacheFile = cacheDir.appending(path: fileName)
        if !FileManager.default.fileExists(atPath: cacheFile.path) {
            try? self.write(to: cacheFile)
        }
        return try? Data(contentsOf: cacheFile, options: .alwaysMapped)
    }

     func count<T>(of type: T.Type) -> Int {
         Int(self.count / MemoryLayout<T>.size)
     }
}

fileprivate extension Data {

    func unsafePointer<T>() -> UnsafePointer<T>? {
        let result = withUnsafeBytes { (pointer) -> UnsafePointer<T>? in
            pointer.baseAddress?.assumingMemoryBound(to: T.self)
        }
        return result
    }
}
