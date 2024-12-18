import SwiftUI

struct ContentView: View {
    var body: some View {
        LockView(lockType: .biometric, lockPin: "1234", isEnabled: true) {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, world!")
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
