import SwiftUI

struct ContentView: View {
    @State private var counter = 0

    var body: some View {
        VStack(spacing: 128) {
            BannerView()
                .keyframeAnimator(
                    initialValue: BannerAnimationValues(),
                    trigger: counter,
                    content: { view, value in
                        view
                            .scaleEffect(value.scale)
                            .rotationEffect(value.rotation)
                    },

                    keyframes: { value in
                        KeyframeTrack(\.scale) {
                            LinearKeyframe(1.0, duration: 0.5)
                            SpringKeyframe(2.0, duration: 0.4, spring: .snappy)
                            CubicKeyframe(1.0, duration: 0.6)
                        }
                        KeyframeTrack(\.rotation) {
                            SpringKeyframe(.degrees(-35), duration: 0.4, spring: .smooth)
                            SpringKeyframe(.degrees(35), duration: 0.8, spring: .smooth)
                            LinearKeyframe(.degrees(0), duration: 0.3)
                        }
                    }
                )
            Button("Animate", action: { counter += 1 })
        }
    }

    struct BannerAnimationValues {
        var rotation: Angle = .zero
        var scale = 1.0
    }
}

struct BannerView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .background(
            LinearGradient(
                colors: [.orange, .yellow],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    ContentView()
}
