import SwiftUI

struct ActorsView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            BrowseView()
                .tabItem {
                    Label("Browse", systemImage: "magnifyingglass")
                }
        }
    }
}

struct HomeView: View{
    @State private var text:String = ""
    let manager = DataManager.instance
    let actorManager = ActorDatamanager.instance
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    var body: some View{
        ZStack{
            Color.pink.opacity(0.8).ignoresSafeArea()
            Text(text)
                .font(.headline)
                .foregroundColor(.white)
                .fontWeight(.bold)
        }
        .onReceive(timer) { _ in
            //getDataInMain()
            //getDateBackgroundSafe()
            getDataUsingActorSafe()
            
        }
    }
}

extension HomeView{
    private func getDataInMain(){
        if let data = manager.getData(){
            text = data
        }
    }
    
    private func getDateBackgroundSafe(){
        DispatchQueue.global(qos: .background).async {
            manager.getDataSafe { data in
                if let data = data{
                    self.text = data
                }
            }
        }
    }
    
    private func getDataUsingActorSafe(){
        Task{
            if let data = await actorManager.getRandomData(){
                text = data
            }
        }
        _ = actorManager.getSavedData()
        _ = actorManager.nonisolatedValue
        // whether inside Task block or not, its returned value as nonisolated can be used
    }
}

struct BrowseView: View{
    @State private var text:String = ""
    let manager = DataManager.instance
    let actorManager = ActorDatamanager.instance
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    var body: some View{
        ZStack{
            Color.purple.opacity(0.5).ignoresSafeArea()
            Text(text)
                .font(.headline)
                .foregroundColor(.white)
                .fontWeight(.bold)
        }
        .onReceive(timer) { _ in
            //getDataInMain()
            //getDateBackgroundSafe()
            getDataUsingActorSafe()
            
        }
    }
}

extension BrowseView{
    
    private func getDataInMain(){
        if let data = manager.getData(){
            text = data
        }
    }
    
    private func getDateBackgroundSafe(){
        DispatchQueue.global(qos: .utility).async {
            manager.getDataSafe{ data in
                if let data = data{
                    text = data
                }
            }
        }
    }
    
    private func getDataUsingActorSafe(){
        Task{
            if let data = await actorManager.getRandomData(){
                text = data
            }
        }
        _ = actorManager.getSavedData()
        _ = actorManager.nonisolatedValue
        // whether inside Task block or not, its returned value as nonisolated can be used
    }
}



struct ActorsView_Previews: PreviewProvider {
    static var previews: some View {
        ActorsView()
    }
}


/*
 Current Thread: <_NSMainThread: 0x6000026a81c0>{number = 1, name = main}
 Current Thread: <_NSMainThread: 0x6000026a81c0>{number = 1, name = main}
 */
