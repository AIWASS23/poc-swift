import SwiftUI
import os

@main
struct Video3DApp: App {
    @State private var player = PlayerModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(player)
        }
    }
}
