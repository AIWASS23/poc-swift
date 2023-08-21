
import Foundation
import Combine

final class InsectData: ObservableObject {
    @Published var insects = testInsects
    
}
var testInsects : [Insect]{
    guard let url = Bundle.main.url(forResource: "insectData", withExtension: "json"),
    
        let data = try? Data(contentsOf: url)
        else{
            return[]
    }
    let decoder  = JSONDecoder()
    let array = try?decoder.decode([Insect].self, from: data)
    print("This is array",array)
    return array ??  [testInsect]
}
