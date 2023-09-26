import SwiftUI

struct AnimationBorder<Content>: View where Content: View {
    private let lineWidth: CGFloat
    private let cornerRadius: CGFloat
    private let speed: Double
    private let colors: [Color]
    private let content: () -> Content
    @State private var rotation: CGFloat = 0
    @State private var size: CGSize = .init(width: 500, height: 500)
    
    private var hypotenuses: CGFloat {
        sqrt(pow(size.width, 2) + pow(size.height, 2))
    }
    
    init(
        lineWidth: CGFloat = 4,
        cornerRadius: CGFloat = 20,
        speed: Double = 3,
        colors: [Color] = [.red, .yellow, .green, .blue, .purple],
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.lineWidth = lineWidth
        self.cornerRadius = cornerRadius
        self.speed = speed
        self.colors = colors
        self.content = content
    }
    
    var body: some View {
        ZStack {
            content()
                .background(
                    GeometryReader {
                        Color.clear.preference(key: SizePreferenceKey.self, value: $0.size)
                    }
                )
            
            RoundedRectangle(cornerSize: .zero)
                .frame(width: hypotenuses, height: hypotenuses)
                .foregroundStyle(
                    LinearGradient(
                        gradient: .init(colors: colors),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .rotationEffect(.degrees(rotation))
                .mask {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(lineWidth: lineWidth)
                        .frame(
                            width: size.width - lineWidth / 2,
                            height: size.height - lineWidth / 2
                        )
                }
        }
        .frame(width: size.width, height: size.height)
        .onAppear {
            withAnimation(
                .linear(duration: speed)
                .repeatForever(autoreverses: false)
            ) {
                rotation = 360
            }
        }
        .onPreferenceChange(SizePreferenceKey.self) { size = $0 }
    }
}

private struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}
