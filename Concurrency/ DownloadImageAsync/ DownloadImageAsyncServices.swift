import Foundation
import SwiftUI
import Combine

class DownloadImageAsyncServices{
    
    let url: String
    
    init(url: String) {
        self.url = url
    }
    
    func getUrl() -> URL?{
        guard let url = URL(string: url) else {return nil}
        return url
    }
    
    func handleResponse(data: Data?, response: URLResponse?) -> UIImage?{
        guard
            let data = data,
            let image = UIImage(data: data),
            let response = response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300 else {
            return nil
        }
        return image
    }
    
    func downloadWithEscaping(completionHandler: @escaping (_ image: UIImage? ,_ error: Error?) -> Void){
        guard let url = getUrl() else {return}
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let data = data,
                let image = UIImage(data: data),
                let response = response as? HTTPURLResponse,
                response.statusCode >= 200 && response.statusCode < 300 else{
                    completionHandler(nil,error)
                return
                }
            completionHandler(image,nil)
        }
        .resume()
    }
    
    func downloadWithEscaping2(completionHandler: @escaping (_ image: UIImage?, _ error: Error?) -> Void){
        guard let url = getUrl() else {return}
        URLSession.shared.dataTask(with: url) { data, response, error in
            let image = self.handleResponse(data: data, response: response as? HTTPURLResponse)
            completionHandler(image,nil)
        }
        .resume()
    }
    
    func downloadWithCombine() -> AnyPublisher<UIImage?,Error>{
        guard let url = self.getUrl() else {return Fail(error: URLError(.badURL)).eraseToAnyPublisher()}
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(handleResponse)
            .mapError{$0}
            .eraseToAnyPublisher()
    }
    
    func downloadImageWithAsync() async throws -> UIImage?{
        // 1. weak self -> no need
        // 2. safer code (completionHandler usage X)
        
        guard let url = self.getUrl() else {throw URLError(.badURL)}
        
        do{
            let (data,response) = try await URLSession.shared.data(from: url)
            return handleResponse(data: data, response: response)
        }catch{
            throw error
        }
    }
}
