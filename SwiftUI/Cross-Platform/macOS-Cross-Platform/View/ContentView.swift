
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var insectData:InsectData
    @State var selectedInsect:Insect?
    var body: some View {
        NavigationView {
            VStack{
                MacInsectListView(selectedInsect: $selectedInsect)
            }
            .frame(minWidth: 0.250, maxWidth: 400)
            if let selectedInsect = selectedInsect{
                ScrollView{
                    InsectDetailView(insect: selectedInsect)
                }
            }else{
                EmptyView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(InsectData())
    }
}
