import SwiftUI

struct ContentView: View {
    @State private var isDrizzleHidden = true

    var body: some View {
        VStack(spacing: 50) {
            ReplaceView()
            VariableColorView()
            PulseView()
            ScaleView()
            BounceView()
            AppearDisappearView()
        }
        .padding()
    }
}

struct ReplaceView: View {
    @State private var isActive = false

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(
                    systemName: isActive ? "pause.circle.fill" : "play.circle.fill"
                )
                .contentTransition(.symbolEffect(.replace))

                Image(
                    systemName: isActive ? "pause.circle.fill" : "play.circle.fill"
                )
                .contentTransition(.symbolEffect(.replace.offUp))

                Image(
                    systemName: isActive ? "pause.circle.fill" : "play.circle.fill"
                )
                .contentTransition(.symbolEffect(.replace.upUp))
            }
            .imageScale(.large)

            Button("Replace") { isActive.toggle() }
        }
    }
}

struct VariableColorView: View {
    @State private var isActive = false

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "rainbow")
                    .symbolEffect(.variableColor, options: .speed(0.1), isActive: isActive)
                Image(systemName: "rainbow")
                    .symbolEffect(.variableColor.iterative, options: .speed(0.1), isActive: isActive)
                Image(systemName: "rainbow")
                    .symbolEffect(.variableColor.iterative.reversing, options: .speed(0.1), isActive: isActive)

            }
            .symbolRenderingMode(.multicolor)
            .imageScale(.large)
            Button("Variable Color") { isActive.toggle() }
        }
    }
}

struct PulseView: View {
    @State private var isActive = false

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "moonphase.first.quarter")
                    .symbolEffect(.pulse, isActive: isActive)
                Image(systemName: "moonphase.first.quarter")
                    .symbolEffect(.pulse, options: .speed(0.1), isActive: isActive)
                Image(systemName: "moonphase.first.quarter")
                    .symbolEffect(.pulse, options: .speed(5), isActive: isActive)

            }
            .imageScale(.large)
            Button("Pulse") { isActive.toggle() }
        }
    }
}

struct ScaleView: View {
    @State private var isActive = false

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "drop.fill")
                    .symbolEffect(.scale.up, isActive: isActive)
                Image(systemName: "drop.fill")
                    .symbolEffect(.scale.down, options: .speed(0.1), isActive: isActive)
                Image(systemName: "drop.fill")
                    .symbolEffect(.scale.down, options: .speed(5), isActive: isActive)

            }
            .imageScale(.large)
            Button("Scale") { isActive.toggle() }
        }
    }
}

struct BounceView: View {
    @State private var value = 0

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "snowflake")
                    .symbolEffect(.bounce, value: value)
                Image(systemName: "snowflake")
                    .symbolEffect(.bounce, options: .speed(0.1), value: value)
                Image(systemName: "snowflake")
                    .symbolEffect(.bounce, options: .repeat(2), value: value)

            }
            .imageScale(.large)
            Button("Bounce") { value += 1 }
        }
    }
}

struct AppearDisappearView: View {
    @State private var isDrizzleHidden = true

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "cloud.fill")
                Image(systemName: "cloud.drizzle.fill")
                    .symbolEffect(.disappear, isActive: isDrizzleHidden)
                Image(systemName: "cloud.heavyrain.fill")
            }
            .imageScale(.large)
            HStack {
                Image(systemName: "cloud.fill")
                if !isDrizzleHidden {
                    Image(systemName: "cloud.drizzle.fill")
                        .transition(.symbolEffect(.automatic))
                }
                Image(systemName: "cloud.heavyrain.fill")
            }
            .imageScale(.large)
            Button("Appear/Disapper") {
                isDrizzleHidden.toggle()
            }
        }
    }
}

#Preview {
    ContentView()
}
