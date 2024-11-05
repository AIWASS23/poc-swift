//
//  FileManager+Extensions.swift
//  
//
//  Created by Marcelo de Araújo
//

import Foundation

private let cacheDirName = "cache"

extension FileManager {

    var cacheDirectory: URL {
        let cacheDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        if let bundleIdentifier = Bundle.main.bundleIdentifier {

            let url = cacheDir.appending(path: bundleIdentifier).appending(path: cacheDirName)

            try? FileManager.default.createDirectory(atPath: url.path, withIntermediateDirectories: true, attributes: nil)

            return url
        }
        return cacheDir
    }
}
