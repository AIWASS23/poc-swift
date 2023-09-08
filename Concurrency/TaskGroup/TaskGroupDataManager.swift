import Foundation
import SwiftUI

protocol TaskGroupDataProtocol{
    func fetchImage(from urlString:String) async throws -> UIImage
    func fetImageWithAyncLet(from urlString:String) async throws -> [UIImage]
    func fetchImagesWithTaskGroup(from urlString: String) async throws -> [UIImage]
    func fetchImagesWithTaskGroupWithNumber(from urlString: String, number: Int) async throws -> [UIImage]
    func fetchImagesWithTaskGroupWithNumberWithOptional(from urlString: String, number: Int) async throws -> [UIImage]
}

class TaskGroupDataManager: TaskGroupDataProtocol {
    func fetchImage(from urlString: String) async throws -> UIImage {
        do{
            guard let url = getUrl(from: urlString) else {throw URLError(.badURL)}
            let (data,_) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else { throw URLError(.badURL)}
            return image
        }catch{
            throw error
        }
    }
    
    func fetImageWithAyncLet(from urlString: String) async throws -> [UIImage] {
        guard let _ = getUrl(from: urlString) else {throw URLError(.badURL)}
        async let fetchImage1 = fetchImage(from: urlString)
        async let fetchImage2 = fetchImage(from: urlString)
        async let fetchImage3 = fetchImage(from: urlString)
        async let fetchImage4 = fetchImage(from: urlString)
        let (image1,image2,image3,image4) = try await ( fetchImage1,fetchImage2,fetchImage3,fetchImage4)
        return [image1,image2,image3,image4]
    }
    
    func fetchImagesWithTaskGroup(from urlString: String) async throws -> [UIImage] {
        guard let _ = getUrl(from: urlString) else {throw URLError(.badURL)}
        return try await withThrowingTaskGroup(of: UIImage.self){ group in
            // group: ThrowingTaskGroup<UIImage, Error>
            var images:[UIImage] = []
            
            group.addTask {
                try await self.fetchImage(from: urlString)
            }
            
            group.addTask {
                try await self.fetchImage(from: urlString)
            }
            
            group.addTask {
                try await self.fetchImage(from: urlString)
            }
            
            group.addTask {
                try await self.fetchImage(from: urlString)
            }
            
            for try await image in group{
                // Wait for each of those tasks until their results come back
                images.append(image)
            }
            
            return images
        }
    }
    
    func fetchImagesWithTaskGroupWithNumber(from urlString: String, number: Int) async throws -> [UIImage] {
        guard let _ = getUrl(from: urlString) else { throw URLError(.badURL)}
        
        return try await withThrowingTaskGroup(of: UIImage.self){ group in
            var images:[UIImage] = []
            
            for _ in 0..<number{
                group.addTask {
                    try await self.fetchImage(from: urlString)
                }
            }
            
            for try await image  in group{
                // Wait for each of those tasks until their results come back
                images.append(image)
            }
            
            return images
        }
    }
    
    func fetchImagesWithTaskGroupWithNumberWithOptional(from urlString: String, number: Int) async throws -> [UIImage] {
        guard let _ = getUrl(from: urlString) else {throw URLError(.badURL)}
        
        return try await withThrowingTaskGroup(of: UIImage?.self){ group in
            // group: ThrowingTaskGroup<UIImage, Error>
            
            var images:[UIImage] = []
        
            for index in 0..<number{
                group.addTask {
                    try? await self.fetchImage(from: index == 3 ? "" : urlString)
                }
            }
            
            for try await image in group{
                // Wait for each of those tasks until their results come back
                if let image = image{
                    images.append(image)
                }
            }
            
            return images
        }
    }
    
    private func getUrl(from urlString: String) -> URL?{
        guard let url = URL(string: urlString) else {return nil}
        return url
    }
}
