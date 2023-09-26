import SwiftUI

struct RatingBar: View {
    private let systemImage: String
    private let elements: Int
    private let font: Font
    private let spacing: CGFloat
    private let color: ColorStyle
    private let secondaryColor: Color
    @Binding var selected: Int
    private var action: ((Int) -> Void)?
    
    init(
        systemImage: String = "star.fill",
        elements: Int = 5,
        font: Font = .largeTitle,
        spacing: CGFloat = .zero,
        color: ColorStyle = .single(.yellow),
        secondaryColor: Color = .gray,
        selected: Binding<Int>,
        action: @escaping (Int) -> Void = {_ in }
    ) {
        self.systemImage = systemImage
        self.elements = elements
        self.font = font
        self.spacing = spacing
        self.color = color
        self.secondaryColor = secondaryColor
        self._selected = selected
        self.action = action
    }
    
    var body: some View {
        stars.overlay(overlay.mask(stars))
    }
}

extension RatingBar {
    enum ColorStyle {
        case single(Color)
        case multi([Color])
    }
}

private extension RatingBar {
    var stars: some View {
        HStack(spacing: spacing) {
            if elements > 0 {
                ForEach(1...elements, id: \.self) { index in
                    Image(systemName: systemImage)
                        .font(font)
                        .foregroundColor(secondaryColor)
                        .onTapGesture {
                            if let action {
                                action(index)
                            }
                            withAnimation(.easeInOut) {
                                selected = index
                            }
                        }
                }
            }
        }
    }
    
    var overlay: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: gradientColors),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: CGFloat(selected) / CGFloat(elements) * geometry.size.width)
            }
        }
        .allowsHitTesting(false)
    }
    
    var gradientColors: [Color] {
        switch color {
        case let .single(color):
            return [color]
        case let .multi(color):
            return color
        }
    }
}
