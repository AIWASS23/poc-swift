
import SwiftUI

struct ContentView: View {
    var body: some View {
        InsectListView{WatchInsectDetailView(insect: $0) }
        .environmentObject(InsectData())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
