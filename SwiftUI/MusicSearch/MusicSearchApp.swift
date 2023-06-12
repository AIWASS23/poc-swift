import SwiftUI

@main
struct Music_SearchApp: App {
    var body: some Scene {
        WindowGroup {
          ContentView(viewModel: SongListViewModel())
        }
    }
}