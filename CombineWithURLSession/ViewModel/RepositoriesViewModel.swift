import Foundation
import Combine

class RepositoriesViewModel:ObservableObject {
    
    @Published var respositories:[Item] = []
    private var cancellables = Set<AnyCancellable>()
    private let service = RepositoriesService.instance
    
    
    init(){
        addSubscriber()
    }
    
    func addSubscriber(){
        service.$repositories
            .sink { [weak self] repos in
                guard let self = self else {return}
                self.respositories = repos
            }
            .store(in: &cancellables)
    }
}
