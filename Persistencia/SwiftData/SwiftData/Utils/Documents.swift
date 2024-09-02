//
//  Documents.swift
//  TestSwiftData
//
//  Created by marcelodearaujo on 29/08/24.
//

import Foundation

struct Files {
    

    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    
    static func saveDataToSandbox(data: Data, fileName: String) {
        let fileURL = Files.getDocumentsDirectory().appendingPathComponent(fileName)
        do {
            try data.write(to: fileURL)
            print("\(fileURL.path)")
        } catch {
            print("\(error)")
        }
    }
    
    static func deleteFileFromSandbox(fileName: String) {
        let fileURL = Files.getDocumentsDirectory().appendingPathComponent(fileName)
        do {
            try FileManager.default.removeItem(at: fileURL)
            print("\(fileURL.path)")
        } catch {
            print("\(error)")
        }
    }
    
    static func loadBundleJSONFile<T: Decodable>(_ filename: String) -> T {

        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: Files.loadBundleData(filename))
        } catch {
            fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
        }
    }
    
    static func loadBundleData(_ filename: String) -> Data {
        let data: Data
        guard let file = Bundle.main.url(forResource: filename, withExtension: nil) else {
            let str = "Hello"
            if let data = str.data(using: .utf8) {
                return data
            } else {
                print("Failed to convert string to data")
            }
            return Data()
//            fatalError("Couldn't find \(filename) in main bundle.")
        }
        do {
            data = try Data(contentsOf: file)
            return data
        } catch {
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }
    }
    
    static func loadBundleString(_ filename: String) -> String {
        let d = Files.loadBundleData(filename)
        return String(decoding: d, as: UTF8.self)
    }
    
    static func loadFileContent(path: String) -> String {
        do {
            return try String(contentsOfFile: path, encoding: String.Encoding.utf8)
        } catch {
            return ""
        }
    }
    
    static func showSwiftDataStoreFileLocation() {
        guard let urlApp = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).last else { return }

        let url = urlApp.appendingPathComponent("default.store")
        if FileManager.default.fileExists(atPath: url.path) {
            print("swiftdata db at \(url.absoluteString)")
        }
    }
    
    static func writeToDownload(fileName: String, content: String) {
        try! content.write(toFile: "/Users/marcelodearaujo/Downloads/\(fileName)", atomically: true, encoding: String.Encoding.utf8)
    }
}


