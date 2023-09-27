import SwiftUI

@main
struct OpenAndDismissImmersiveSpaceApp: App {
    var body: some Scene {
        WindowGroup() {
            ContentView()
        }
        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }
    }
}
