import SwiftUI

struct ContentView: View {
    @State private var counter = 0

    var body: some View {
        VStack(spacing: 64) {

            BannerView()
                .phaseAnimator([false, true], trigger: counter) { content, isEnabled in
                    content
                        .scaleEffect(isEnabled ? 2.0 : 1.0)
                } 
            
                animation: { isEnabled in
                    isEnabled ? .bouncy : .easeOut(duration: 0.7)
                }
            Button("Trigger", action: { counter += 1 })
        }
    }
}

enum BannerAnimationPhase: CaseIterable {
    case initial, middle, final

    var animation: Animation {
        switch self {
        case .initial: .easeIn
        case .middle: .linear
        case .final: .easeOut
        }
    }

    var gradientStartPoint: UnitPoint {
        switch self {
        case .initial: .bottomLeading
        case .middle: .leading
        case .final: .topLeading
        }
    }

    var rotation: Angle {
        switch self {
        case .initial: .degrees(-15)
        case .middle: .degrees(15)
        case .final: .zero
        }
    }

    var scale: Double {
        switch self {
        case .initial: 1.5
        case .middle: 1.7
        case .final: 1.0
        }
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
    }
}

#Preview {
    ContentView()
}
