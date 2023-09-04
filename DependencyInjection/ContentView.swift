import SwiftUI
import Combine

struct PostModel: Identifiable, Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

protocol DataServiceProtocol{
    func getData() -> AnyPublisher<[PostModel], Error>?
}

class ProductionDataService: DataServiceProtocol{
    
    let urlString: String
    
    init(urlString:String = "https://jsonplaceholder.typicode.com/posts") {
        self.urlString = urlString
    }
    
    func getData() -> AnyPublisher<[PostModel],Error>? {
        guard let url = getUrl() else {return nil}
        return URLSession.shared.dataTaskPublisher(for: url)
            .map{$0.data}
            .decode(type: [PostModel].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func getUrl() -> URL? {
        guard let url = URL(string: urlString) else {return nil}
        return url
    }
}


class MockDataServices: DataServiceProtocol{
    
    let postData:[PostModel]
    
    init(postData: [PostModel]?) {
        self.postData = postData ?? [PostModel(userId: 1, id: 2, title: "One", body: "One is One")]
    }
    
    func getData() -> AnyPublisher<[PostModel],Error>? {
        Just(postData)
            .tryMap{$0}
            .eraseToAnyPublisher()
    }
}




class ViewModel: ObservableObject {
    
    @Published var dataArray:[PostModel] = []
    var cancellables = Set<AnyCancellable>()
    let dataServies:DataServiceProtocol
    
    init(dataService:DataServiceProtocol){
        self.dataServies = dataService
        loadPosts()
    }
    
    func loadPosts(){
        guard let data = dataServies.getData() else {return}
        data
            .sink { completion in
                switch completion{
                case .finished:
                    print("Sucess")
                case .failure(let error):
                    print("Error:- \(error.localizedDescription)")
                }

            } receiveValue: { [weak self] returnedData in
                guard let self = self else {return}
                self.dataArray = returnedData
            }
            .store(in: &cancellables)

    }
}

struct ContentView: View {
    
    @StateObject private var viewModel: ViewModel
    
    init(dataService: DataServiceProtocol) {
        _viewModel = StateObject(wrappedValue: ViewModel(dataService: dataService))
    }
    
    
    var body: some View {
        ScrollView{
            VStack{
                ForEach(viewModel.dataArray){ post in
                    Text(post.title)
                }
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(dataService: ProductionDataService())
    }
}
