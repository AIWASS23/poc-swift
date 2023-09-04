import Foundation
import Combine

class RepositoriesService{
    
    static let instance = RepositoriesService()
    private var cancellables = Set<AnyCancellable>()
    private let repositoriesUrl = "https://api.github.com/search/repositories?q=swift"
    @Published var repositories:[Item] = []
    
    private init(){
        getReposApiRequest()
    }
    
    private func getReposApiRequest(){
        guard let url = URL(string: repositoriesUrl) else {return}
        
        URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap(handleOutput)
            .decode(type: RepositoriesModel.self, decoder: JSONDecoder())
            .sink { completion in
                switch completion{
                case .finished:
                    print("Finished")
                case .failure(let error):
                    print("Error \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] returnedRepos in
                guard let self = self else {return}
                self.repositories = returnedRepos.items
                
            }
            .store(in: &cancellables)
    }
    
    func handleOutput(output:URLSession.DataTaskPublisher.Output) throws -> Data{
        guard
            let response = output.response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300 else {
            throw URLError(.badServerResponse)
        }
        
        return output.data
    }
}
