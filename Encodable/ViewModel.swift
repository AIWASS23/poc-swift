import Foundation

class ViewModel:ObservableObject {
    
    @Published var customer:CustomerModel? = nil
    
    init(){
        getDataDecoder()
    }
    
    
    func getDataDictonary() {
        guard let data = getJsonData() else {return}
        let jsonString = String(data: data, encoding: .utf8)
        //  Optional("{\"isPremium\":true,\"name\":\"Marcelo\",\"id\":\"222\",\"points\":5}")
        
        if let localData = try? JSONSerialization.jsonObject(with: data),
           let dictionary = localData as? [String:Any],
           let id = dictionary["id"] as? String,
           let name = dictionary["name"] as? String,
           let point = dictionary["points"] as? Int,
           let isPremium = dictionary["isPremium"] as? Bool {
            customer = CustomerModel(id: id, name: name, points: point, isPremium: isPremium)
        }
    }
    
    func getDataDecoder() {
        guard let data = getJsonData2() else {return}
        do{
            customer = try JSONDecoder().decode(CustomerModel.self, from: data)
        }catch let error{
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func getJsonData() -> Data? {
        let dictionary:[String:Any] = [
            "id" : "222",
            "name" : "Marcelo",
            "points" : "5",
            "isPremium" : true
        ]
        
        do{
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary)
            return jsonData
        } catch let error {
            print("Error: \(error.localizedDescription)")
        }
        return nil
    }
    
    func getJsonData2() -> Data? {
        let customer = CustomerModel(id: "111", name: "Araújo", points: 5, isPremium: true)
        let jsonData = try? JSONEncoder().encode(customer)
        return jsonData
    }
}
