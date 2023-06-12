import UIKit

class ViewController: UIViewController {
    @IBOutlet var postMethodButton: UIButton!
    @IBOutlet var getMethodButton: UIButton!
    @IBOutlet var putMethodButton: UIButton!
    @IBOutlet var deleteMethodButton: UIButton!
    
    var detailsVCPrintedJson: String?
    var detailsVCTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func postMethodAction(_ sender: UIButton) { postMethod() }
    
    @IBAction func getMethodAction(_ sender: UIButton) { getMethod() }
    
    @IBAction func putMethodAction(_ sender: UIButton) { putMethod() }
    
    @IBAction func deleteMethodAction(_ sender: UIButton) { deleteMethod() }
    
    func postMethod() {
        /*
         The following commented code is about when you want to make a POST call with parameters, like consumer key, consumer secret e.t.c
         */
        
//        guard let components = URLComponents(string: "MY_URL") else {
//            print("Error: cannot create URLCompontents")
//            return
//        }
//        components.queryItems = [
//            URLQueryItem(name: "consumer_key", value: "MY_CONSUMER_KEY"),
//            URLQueryItem(name: "consumer_secret", value: "MY_CONSUMER_SECRET")
//        ]
//        guard let url = components.url else {
//            print("Error: cannot create URL")
//            return
//        }
        guard let url = URL(string: "http://dummy.restapiexample.com/api/v1/create") else {
            print("Error: cannot create URL")
            return
        }
        
        // Create model
        struct UploadData: Codable {
            let name: String
            let salary: String
            let age: String
        }
        
        // Add data to the model
        let uploadDataModel = UploadData(name: "Jack", salary: "3540", age: "23")
        
        // Convert model to JSON data
        guard let jsonData = try? JSONEncoder().encode(uploadDataModel) else {
            print("Error: Trying to convert model to JSON data")
            return
        }
        // Create the url request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") // the request is JSON
        request.setValue("application/json", forHTTPHeaderField: "Accept") // the response expected to be in JSON format
        request.httpBody = jsonData
        // If you are using Basic Authentication uncomment the follow line and add your base64 string
//        request.setValue("Basic MY_BASIC_AUTH_STRING", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Error: error calling POST")
                print(error!)
                return
            }
            guard let data = data else {
                print("Error: Did not receive data")
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print("Error: HTTP request failed")
                return
            }
            do {
                guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    print("Error: Cannot convert data to JSON object")
                    return
                }
                guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                    print("Error: Cannot convert JSON object to Pretty JSON data")
                    return
                }
                guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                    print("Error: Couldn't print JSON in String")
                    return
                }
                
                self.openDetailsVC(jsonString: prettyPrintedJson, title: "POST METHOD")
            } catch {
                print("Error: Trying to convert JSON data to string")
                return
            }
        }.resume()
    }
    
    func getMethod() {
        /*
         The following commented code is about when you want to make a GET call with parameters, like consumer key, consumer secret e.t.c
         */
        
//        guard let components = URLComponents(string: "MY_URL") else {
//            print("Error: cannot create URLCompontents")
//            return
//        }
//        components.queryItems = [
//            URLQueryItem(name: "consumer_key", value: "MY_CONSUMER_KEY"),
//            URLQueryItem(name: "consumer_secret", value: "MY_CONSUMER_SECRET")
//        ]
//        guard let url = components.url else {
//            print("Error: cannot create URL")
//            return
//        }
        guard let url = URL(string: "http://dummy.restapiexample.com/api/v1/employees") else {
            print("Error: cannot create URL")
            return
        }
        // Create the url request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        // If you are using Basic Authentication uncomment the follow line and add your base64 string
//        request.setValue("Basic MY_BASIC_AUTH_STRING", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Error: error calling GET")
                print(error!)
                return
            }
            guard let data = data else {
                print("Error: Did not receive data")
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print("Error: HTTP request failed")
                return
            }
            do {
                guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    print("Error: Cannot convert data to JSON object")
                    return
                }
                guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                    print("Error: Cannot convert JSON object to Pretty JSON data")
                    return
                }
                guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                    print("Error: Could print JSON in String")
                    return
                }
                
                self.openDetailsVC(jsonString: prettyPrintedJson, title: "GET METHOD")
            } catch {
                print("Error: Trying to convert JSON data to string")
                return
            }
        }.resume()
    }
    
    func putMethod() {
        /*
         The following commented code is about when you want to make a PUT call with parameters, like consumer key, consumer secret e.t.c
         */
        
//        guard let components = URLComponents(string: "MY_URL") else {
//            print("Error: cannot create URLCompontents")
//            return
//        }
//        components.queryItems = [
//            URLQueryItem(name: "consumer_key", value: "MY_CONSUMER_KEY"),
//            URLQueryItem(name: "consumer_secret", value: "MY_CONSUMER_SECRET")
//        ]
//        guard let url = components.url else {
//            print("Error: cannot create URL")
//            return
//        }
        guard let url = URL(string: "https://reqres.in/api/users/2") else {
            print("Error: cannot create URL")
            return
        }
        
        // Create model
        struct UploadData: Codable {
            let name: String
            let job: String
        }
        
        // Add data to the model
        let uploadDataModel = UploadData(name: "Nicole", job: "iOS Developer")
        
        // Convert model to JSON data
        guard let jsonData = try? JSONEncoder().encode(uploadDataModel) else {
            print("Error: Trying to convert model to JSON data")
            return
        }
        
        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        // If you are using Basic Authentication uncomment the follow line and add your base64 string
//        request.setValue("Basic MY_BASIC_AUTH_STRING", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Error: error calling PUT")
                print(error!)
                return
            }
            guard let data = data else {
                print("Error: Did not receive data")
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print("Error: HTTP request failed")
                return
            }
            do {
                guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    print("Error: Cannot convert data to JSON object")
                    return
                }
                guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                    print("Error: Cannot convert JSON object to Pretty JSON data")
                    return
                }
                guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                    print("Error: Could print JSON in String")
                    return
                }
                
                self.openDetailsVC(jsonString: prettyPrintedJson, title: "PUT METHOD")
            } catch {
                print("Error: Trying to convert JSON data to string")
                return
            }
        }.resume()
    }
    
    func deleteMethod() {
        /*
         The following commented code is about when you want to make a DELETE call with parameters, like consumer key, consumer secret e.t.c
         */
        
//        guard let components = URLComponents(string: "MY_URL") else {
//            print("Error: cannot create URLCompontents")
//            return
//        }
//        components.queryItems = [
//            URLQueryItem(name: "consumer_key", value: "MY_CONSUMER_KEY"),
//            URLQueryItem(name: "consumer_secret", value: "MY_CONSUMER_SECRET")
//        ]
//        guard let url = components.url else {
//            print("Error: cannot create URL")
//            return
//        }
        guard let url = URL(string: "https://my-json-server.typicode.com/typicode/demo/posts/1") else {
            print("Error: cannot create URL")
            return
        }
        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        // If you are using Basic Authentication uncomment the follow line and add your base64 string
//        request.setValue("Basic MY_BASIC_AUTH_STRING", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Error: error calling DELETE")
                print(error!)
                return
            }
            guard let data = data else {
                print("Error: Did not receive data")
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print("Error: HTTP request failed")
                return
            }
            do {
                guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    print("Error: Cannot convert data to JSON")
                    return
                }
                guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                    print("Error: Cannot convert JSON object to Pretty JSON data")
                    return
                }
                guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                    print("Error: Could print JSON in String")
                    return
                }
                
                self.openDetailsVC(jsonString: prettyPrintedJson, title: "DELETE METHOD")
            } catch {
                print("Error: Trying to convert JSON data to string")
                return
            }
        }.resume()
    }
    
    func openDetailsVC(jsonString: String, title: String) {
        detailsVCPrintedJson = jsonString
        detailsVCTitle = title
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "detailsseg", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "detailsseg" {
            let destViewController = segue.destination as? DetailsViewController
            destViewController?.title = detailsVCTitle
            destViewController?.jsonResults = detailsVCPrintedJson ?? ""
        }
    }
}