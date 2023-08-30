import Foundation
import Combine

protocol DataServicesProtocol{
    func downloadDataWithEscaping(completion: @escaping (_ items: [String]) -> Void)
    func downloadDatawithCombine() -> AnyPublisher<[String],Error>
    
}


class MockDataServices: DataServicesProtocol{
    
    
    let item:[String]
    
    init(item: [String]?) {
        self.item = item ?? ["One", "Two", "Three"]
    }
    
    func downloadDataWithEscaping(completion: @escaping (_ items: [String]) -> Void){
        DispatchQueue.main.asyncAfter(deadline: .now() + 3){
            completion(self.item)
        }
    }
    
    func downloadDatawithCombine() -> AnyPublisher<[String],Error>{
        Just(item)
            .tryMap { publishedItems in
                guard !publishedItems.isEmpty else {
                    throw URLError(.badServerResponse)
                }
                return publishedItems
            }
            .eraseToAnyPublisher()
    }
    
}
