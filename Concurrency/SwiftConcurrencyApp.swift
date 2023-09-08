import SwiftUI

@main
struct SwiftConcurrencyApp: App {
    var body: some Scene {
        WindowGroup {
            // 1
            //DoCatchTryThrowView(manager: DoCatchTryThrowDataManager())
            
            // 2
            //DownloadImageAsyncView()
            
            // 3
            //AsyncAwaitView()
            
            // 4
            //TaskHomeView()
            
            // 5
            //AsyncLetView()
            
            // 6
            //TaskGroupView(manager: TaskGroupDataManager(), urlString: "https://picsum.photos/200")
            
            // 7
            //CheckedContinuationView(dataService: CheckedContinuationDataServices(), urlString: "https://picsum.photos/200")
            
            // 8
           // StructClassActor()
            //StructClassActorHomeView()
            
            // 9
            ActorsView()
        }
    }
}
