import Foundation
import Combine

class CombineFuturesViewModel: ObservableObject {
    @Published var title:String = "Initial Value"
    var cancellables = Set<AnyCancellable>()
    let url = URL(string: "https://www.google.com")!
    
    init(){
        //downLoadWithCombine()
        //downloadWithEscapingClosure()
        downloadWithFuturePublisher()
    }
    
    func downLoadWithCombine(){
        getCombinePublisher()
            .sink { _ in
                
            } receiveValue: {[weak self] returnedValue in
                guard let self = self else {return}
                self.title = returnedValue
            }
            .store(in: &cancellables)
    }
    
    func downloadWithEscapingClosure(){
        getEscapingClosure { [weak self] returnedValue, error in
            guard let self = self else {return}
            self.title = returnedValue
        }
    }
    
    func downloadWithFuturePublisher(){
        getFuturePublisher()
            .sink { _ in
                
            } receiveValue: { [weak self] returnedValue in
                guard let self = self else {return}
                self.title = returnedValue
            }
            .store(in: &cancellables)
    }
    
    func downloadWithFuturePublisher2(){
        dosomethingInFuture()
            .sink { _ in
            } receiveValue: { [weak self] returnedValues in
                guard let self = self else {return}
                self.title = returnedValues
            }

    }
    
    func getCombinePublisher() -> AnyPublisher<String,URLError>{
        URLSession.shared.dataTaskPublisher(for: url)
            .timeout(1, scheduler: DispatchQueue.main)
            .map({ _ in
                return "New Value Combine"
            })
            .eraseToAnyPublisher()
    }
    
    func getEscapingClosure(completionHandler: @escaping (_ value: String,_ error: Error?) -> Void){
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            completionHandler("New Value Closure",nil)
        }
        .resume()
    }
    
    func getFuturePublisher() -> Future<String,Error>{
        Future { [weak self] promise in
            guard let self = self else {return}
            self.getEscapingClosure { retunredValue, error in
                if let error = error {
                    promise(.failure(error))
                }else{
                    promise(.success(retunredValue))
                }
            }
        }
    }
    
    func doSomething(completionHandler: @escaping (_ value: String) -> ()){
        DispatchQueue.main.asyncAfter(deadline: .now() + 10){
            completionHandler("NewValue")
        }
    }
    
    func dosomethingInFuture() -> Future<String,Never>{
        Future { [weak self] promise in
            guard let self = self else {return}
            self.doSomething { value in
                promise(.success(value))
            }
        }
    }
}
