import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = CombineFuturesViewModel()
    var body: some View {
        Text(viewModel.title)
            .font(.largeTitle)
            .fontWeight(.bold)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
