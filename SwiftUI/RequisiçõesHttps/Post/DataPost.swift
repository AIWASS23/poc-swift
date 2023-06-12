import Foundation
import SwiftUI
import Combine

class DataPost: ObservableObject {
    var didChange = PassthroughSubject<DataPost, Never>()
    var formCompleted = false {
        didSet {
            didChange.send(self)
        }
    }
    
    func checkDetails(id: Int, first_name: String, last_name: String, phone_number: String, address: String, birthday: String, create_date: String, updated_date: String) {
        
        let body: [String: Any] = ["data": ["id": id, "first_name": first_name, "last_name": last_name, "birthday": birthday, "phone_number": phone_number, "create_date": create_date, "updated_date": updated_date, "address": address]]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: body)
        
        //  "https://flaskcontact-list-app.herokuapp.com/contacts"
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("\(String(describing: jsonData?.count))", forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            print("-----> data: \(data)")
            print("-----> error: \(error)")
            
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }

            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            print("-----1> responseJSON: \(responseJSON)")
            if let responseJSON = responseJSON as? [String: Any] {
                print("-----2> responseJSON: \(responseJSON)")
            }
        }
        
        task.resume()
    }
}
