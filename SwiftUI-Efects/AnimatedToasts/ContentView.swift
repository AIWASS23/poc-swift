import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Button("Present Toast") {
                Toast.shared.present(
                    title: "Hello World",
                    symbol: "globe",
                    isUserInteractionEnabld: true,
                    timing: .long)
            }
        }
        .padding()
    }
}

#Preview {
    RootView {
        ContentView()
    }
}
