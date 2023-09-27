import SwiftUI
import RealityKit

@main
struct ImmersiveSpaceApp: App {

    @StateObject var model = ImmersiveSpaceViewModel()

    var body: some SwiftUI.Scene {
        ImmersiveSpace {
            RealityView { content in
                content.add(model.setupContentEntity())
            }
            .task {
                await model.runSession()
            }
        }
    }
}
