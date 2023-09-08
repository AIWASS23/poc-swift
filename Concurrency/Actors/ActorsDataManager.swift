import Foundation

class DataManager{
    
    static let instance = DataManager()
    private init(){}
    
    var data:[String] = []
    
    // adding this fix the multi thread before Actors
    let lock = DispatchQueue(label: "customQueue")
    
    
    func getData() -> String?{
        data.append(UUID().uuidString)
        print("Current Thread: \(Thread.current)")
     //HomeView, BrowseView -> Same <Main Thread> (If DispatchQueue.main)
     //HomeView, BrowseView -> Different <Threads> (If DispathQueue.global)
        return data.randomElement()
    }
    
    func getDataSafe(completionHandler: @escaping (_ data: String?) -> Void){
        lock.async {
            self.data.append(UUID().uuidString)
            print("Current Thread: \(Thread.current)")
            completionHandler(self.data.randomElement())
        }
    }
}


actor ActorDatamanager {
    static let instance = ActorDatamanager()
    private init() {}
    
    var data:[String] = []
    nonisolated let nonisolatedValue: String = "No have to worry about Thread-Safety"
    // Call this nonisolated value without await
    
    func getRandomData() -> String?{
        self.data.append(UUID().uuidString)
        print("Current: \(Thread.current)")
        return data.randomElement()
    }
    // Easier to Code than Custom Queue made in Class
    // Await before getting to the Actor
    
    nonisolated func getSavedData() -> String{
        // let data = getRandomData() -> Cannot Use
        // Actor-isolated instance method 'getRandomData()' can not be referenced from a non-isolated context
        return "No have to worry about Thread-Safety"
    }
}
