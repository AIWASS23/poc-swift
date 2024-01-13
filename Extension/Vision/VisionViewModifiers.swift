import SwiftUI

extension View {
    #if os(visionOS)
    func updateImmersionOnChange(
        of path: Binding<[URL]>, 
        isPresentingSpace: Binding<Bool>
    ) -> some View {
        self.modifier(
            ImmersiveSpacePresentationModifier(
                navigationPath: path, 
                isPresentingSpace: isPresentingSpace
            )
        )
    }
    #endif
    
/*    
    Usado apenas em iOS e tvOS para apresentação modal em tela cheia.

    func fullScreenCoverPlayer(player: PlayerModel) -> some View {
        self.modifier(FullScreenCoverModifier(player: player))
    }
*/
}

#if os(visionOS)
struct ImmersiveSpacePresentationModifier: ViewModifier {
    
    @Environment(\.openImmersiveSpace) private var openSpace
    @Environment(\.dismissImmersiveSpace) private var dismissSpace
    @Environment(\.scenePhase) private var scenePhase
    
    @Binding var navigationPath: [URL]
    @Binding var isPresentingSpace: Bool
    
    func body(content: Content) -> some View {
        content
            .onChange(of: navigationPath) {
                Task {
                    // The selection path becomes empty when the user returns to the main library window.
                    if navigationPath.isEmpty {
                        if isPresentingSpace {
                            // Dismiss the space and return the user to their real-world space.
                            await dismissSpace()
                            isPresentingSpace = false
                        }
                    } else {
                        guard !isPresentingSpace else { return }
                        // The navigationPath has one video, or is empty.
                        guard let videoUrl = navigationPath.first else { fatalError() }
                        // Await the request to open the destination and set the state accordingly.
                        switch await openSpace(value: videoUrl) {
                        case .opened: isPresentingSpace = true
                        default: isPresentingSpace = false
                        }
                    }
                }
            }
            // Close the space and unload media when the user backgrounds the app.
            .onChange(of: scenePhase) { _, newPhase in
                if isPresentingSpace, newPhase == .background {
                    Task {
                        await dismissSpace()
                    }
                }
            }
    }
}
#endif
