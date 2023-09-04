import Foundation
import Combine
import Alamofire

class ReposService{
    
    static let instance = ReposService()
    private let reposUrl = "https://api.github.com/search/repositories?q=swift"
    @Published var repos:[Item] = []
    private var cancellables = Set<AnyCancellable>()
    
    private init(){
        fetchRepos()
    }
    
    func fetchRepos(){
        guard let url = URL(string: reposUrl) else {return}
        AF.request(url,method: .get).publishDecodable(type: ReposModel.self)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] response in
                guard let self = self else {return}
                switch response.result{
                case .success(let repos):
                    self.repos = repos.items
                case .failure:
                    print("Error")
                }
            }
            .store(in: &cancellables)
    }
    
}
