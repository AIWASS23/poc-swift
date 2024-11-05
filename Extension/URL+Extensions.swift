//
//  URL+Extensions.swift
//  
//
//  Created by Marcelo de Araújo
//

import CryptoKit
import Foundation

extension URL {

    var sha256Hash: String {
        let hashed = SHA256.hash(data: Data(self.absoluteString.utf8))
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }

    var isCached: Bool {
        switch self.scheme {
        case "https":
            return FileManager.default.fileExists(atPath: cacheURL.path)
        case "file":
            return true
        default:
            return false
        }
    }

    var cacheURL: URL {
        switch self.scheme {
        case "https":
            let cacheDir = FileManager.default.cacheDirectory
            let cachedFileURL = cacheDir.appending(path: sha256Hash)
            return cachedFileURL
        case "file":
            return self
        default:
            return self
        }
    }

    var cacheSize: Int64 {
        if isCached {
            guard let attributes = try? FileManager.default.attributesOfItem(atPath: cacheURL.path),
                  let size = attributes[.size] as? Int64 else { return .zero }
            return size
        }
        return .zero
    }

    var cacheSizeFormatted: String {
        let bcf = ByteCountFormatter()
        bcf.allowedUnits = [.useMB]
        bcf.countStyle = .file
        let string = bcf.string(fromByteCount: cacheSize)
        return string
    }
}

extension URLResponse {

    var isOK: Bool {
        if let code = statusCode()  {
            return 200...299 ~= code
        }
        return false
    }

    func statusCode() -> Int? {
        if let httpResponse = self as? HTTPURLResponse {
            return httpResponse.statusCode
        }
        return nil
    }
}
