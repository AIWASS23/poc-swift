//
//  WebService.swift
//  StoreApp
//
//  Created by Marcelo de Araújo on 09/12/22.
//

import Foundation

class Webservice {
    
    func load<T: Codable>(_ resource: Resource<T>, completion: @escaping (Result<T, NetworkError>) -> Void) {
        
        var request = URLRequest(url: resource.url)
        
        switch resource.method {
        case .get(let queryItems):
            var components = URLComponents(url: resource.url, resolvingAgainstBaseURL: true)
            components?.queryItems = queryItems
            guard let url = components?.url else {
                completion(.failure(.badUrl))
                return
            }
            request = URLRequest(url: url)
            
        case .post(let data):
            request.httpBody = data
        default:
            break
        }
        
        request.allHTTPHeaderFields = resource.headers
        request.httpMethod = resource.method.name
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = ["Content-Type": "application/json"]
        
        let session = URLSession(configuration: configuration)
        session.dataTask(with: request) { data, response, error in
            
            guard let httpResponse = response as? HTTPURLResponse,
                      let data = data,
                      httpResponse.statusCode == 200,
                  error == nil else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let result = try? JSONDecoder().decode(T.self, from: data) else {
                completion(.failure(.decodingError))
                return
            }
            
            completion(.success(result))
            
        }.resume()
    }
}