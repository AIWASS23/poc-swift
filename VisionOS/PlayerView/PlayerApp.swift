import SwiftUI

@main
struct PlayerApp: App {

    @State private var player = PlayerModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(player)
        }

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
                .environment(player)
        }
        .immersionStyle(selection: .constant(.full), in: .full)
    }
}
