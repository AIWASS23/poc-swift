import Foundation
import SwiftUI

protocol CheckedContinuationProtocol {
    func fetchData(url: URL) async throws -> Data
    func fetchData2(url: URL) async throws -> Data
    func fetchDataFromDatabase() async throws -> UIImage
}

class CheckedContinuationDataServices: CheckedContinuationProtocol {
    func fetchData(url: URL) async throws -> Data {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return data
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
    
    func fetchData2(url: URL) async throws -> Data {
        // Convert API's completion handler to async version
        return try await withCheckedThrowingContinuation { continuation in
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    continuation.resume(returning: data)
                } else if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(throwing: URLError(.badURL))
                }
                // A closure that takes an UnsafeContinuation parameter. You must resume the continuation exactly once.
            }
            .resume()
        }
    }
    
    private func fetchDataFromDatabase(completionHandler: @escaping (_ image: UIImage) -> ()) {
        // Mocking Data Fetching from DB
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            completionHandler(UIImage(systemName: "heart.fill")!)
        }
    }
    
    func fetchDataFromDatabase() async throws -> UIImage {
        return await withCheckedContinuation { continuation in
            fetchDataFromDatabase { image in
                continuation.resume(returning: image)
            }
        }
    }
}
