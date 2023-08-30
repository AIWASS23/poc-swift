import Foundation
import Combine

class UnitTestsViewModel: ObservableObject{
    
    @Published var isPremium:Bool
    @Published var dataArray:[String] = []
    @Published var selectedItem:String? = nil
    let dataService:DataServicesProtocol
    
    var cancellables = Set<AnyCancellable>()
    
    init(isPremium:Bool,dataService:DataServicesProtocol = MockDataServices(item: nil)){
        self.isPremium = isPremium
        self.dataService = dataService
    }
    
    func addItem(item:String){
        guard !item.isEmpty else {return}
        dataArray.append(item)
    }
    
    func selectedItem(item:String){
        if let x = dataArray.first(where: {$0 == item}){
            selectedItem = x
        }else{
            selectedItem = nil
        }
    }
    
    func saveItem(item:String) throws{
        guard !item.isEmpty else {
            throw DataError.noData
        }
        
        if let x = dataArray.first(where: {$0 == item}){
            print("Save Item Here!!! \(x)")
        }else{
            throw DataError.itemNotFound
        }
    }
    
    enum DataError:LocalizedError{
        case noData
        case itemNotFound
    }
    
    func downloadWithEscaping(){
        dataService.downloadDataWithEscaping { [weak self] items in
            guard let self = self else {return}
            self.dataArray = items
        }
    }
    
    func downloadWithCombine(){
        dataService.downloadDatawithCombine()
            .sink { _ in
                
            } receiveValue: { [weak self] returnedItems in
                guard let self = self else {return}
                self.dataArray = returnedItems
            }
            .store(in: &cancellables)
    }
}

