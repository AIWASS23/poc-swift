//
//  FileHandle+Extensions.swift
//  
//
//  Created by Marcelo de Araújo
//

import Foundation

extension FileHandle {

    func unsafeType<T>(_ fileOffset: UInt64? = nil) -> T? {
        if let offset = fileOffset {
            do {
                try seek(toOffset: offset)
            } catch {
                debugPrint("💩 unable to seek to \(offset): \(error)")
                return nil
            }
        }

        guard let data = try? read(upToCount: MemoryLayout<T>.size) else { return nil }
        let result: T? = data.unsafeType()
        return result
    }

    func unsafeTypeArray<T>(_ fileOffset: UInt64? = nil, count: Int) -> [T] {

        if let offset = fileOffset {
            do {
                try seek(toOffset: offset)
            } catch {
                debugPrint("💩 unable to seek [\(offset)]: \(error)")
                return []
            }
        }

        do {
            guard let data = try read(upToCount: MemoryLayout<T>.size *  count) else { return [] }
            let result: [T] = data.unsafeTypeArray(count)
            return result
        } catch {
            debugPrint("💩 unable to read data: \(error)")
            return []
        }
    }

    func read(offset: UInt64, count: Int) -> Data? {
        do {
            try seek(toOffset: offset)
            return try read(upToCount: count)
        } catch {
            debugPrint("💩 unable to read data [\(offset):\(count)]: \(error)")
            return nil
        }
    }

    func readMapped(offset: UInt64, count: Int, _ fileName: String) -> Data? {
        let cacheDir = FileManager.default.cacheDirectory
        let cacheFile = cacheDir.appending(path: fileName)
        if !FileManager.default.fileExists(atPath: cacheFile.path) {
            let data = read(offset: offset, count: count)
            try? data?.write(to: cacheFile)
        }
        return try? Data(contentsOf: cacheFile, options: .alwaysMapped)
    }
}
