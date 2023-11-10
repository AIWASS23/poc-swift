import Foundation
import SwiftUI

private struct ScrollViewOffsetKey: EnvironmentKey {
    static let defaultValue: CGFloat = 0
}

public extension EnvironmentValues {
    var scrollViewOffset: CGFloat {
        get { self[ScrollViewOffsetKey.self] }
        set { self[ScrollViewOffsetKey.self] = newValue }
    }
}

private struct ViewOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}

public struct ElasticScrollView<Content: View>: View {
    let content: Content
    let showsIndicators: Bool
    
    @State private var offset: CGFloat = 0
    
    public init(showsIndicators: Bool = true, @ViewBuilder content: () -> Content) {
        self.showsIndicators = showsIndicators
        self.content = content()
    }
    
    public var body: some View {
        GeometryReader { outerGeometry in
            ScrollView(showsIndicators: showsIndicators) {
                ZStack(alignment: .top) {
                    GeometryReader { innerGeometry in
                        Color.clear.preference(key: ViewOffsetKey.self, value: innerGeometry.frame(in: CoordinateSpace.named("scroll")).minY)
                    }
                    .frame(height: 0)
                    
                    content
                }
            }
            .coordinateSpace(name: "scroll")
        }
        .onPreferenceChange(ViewOffsetKey.self) { offset in
            self.offset = max(0, offset)
        }
        .environment(\.scrollViewOffset, offset)
//        ScrollView {
//            VStack(spacing: 0) {
//                GeometryReader { geometry in
//                    Color.clear.preference(key: ViewOffsetKey.self, value: geometry.frame(in: .global).minY)
//                }
//                .frame(height: 0)
//                content
//            }
//        }
//        .overlay(
//            Color.clear
//                .contentShape(Rectangle())
//                .coordinateSpace(name: "TopOffsetBoundingBoxView")
//        )
    }
}

public extension View {
    
    func elasticOffset(factor: CGFloat) -> some View {
        modifier(ElasticOffsetModifier(factor: factor))
    }
    
    func elasticTopPin() -> some View {
        modifier(ElasticTopPinModifier())
    }
    
    func elasticScale() -> some View {
        modifier(ElasticScaleModifier())
    }
}

private struct ElasticOffsetKey: EnvironmentKey {
    static let defaultValue: CGFloat = 0
}

private extension EnvironmentValues {
    var elasticOffset: CGFloat {
        get { self[ElasticOffsetKey.self] }
        set { self[ElasticOffsetKey.self] = newValue }
    }
}

private struct ElasticOffsetModifier: ViewModifier {
    
    @Environment(\.scrollViewOffset) private var offset
    let factor: CGFloat
    
    func body(content: Content) -> some View {
        content
            .offset(y: -offset * factor)
    }
}

private struct ElasticTopPinModifier: ViewModifier {
    
    @State var offset: CGFloat = 0
    
    func body(content: Content) -> some View {
        ZStack(alignment: .top) {
            content
                .opacity(0)
                .withElasticOffsetBinding($offset)
            content
                .padding(.top, -offset)
        }
    }
}

private struct ElasticScaleModifier: ViewModifier {
    
    @State var size: CGSize = .zero
    
    @Environment(\.scrollViewOffset) private var offset
    
    func body(content: Content) -> some View {
        ZStack(alignment: .top) {
            content
                .opacity(0)
                .withSizeBinding($size)
            if size == .zero {
                content
            } else {
                content
                    .scaleEffect(1 + (offset / size.height))
                    .offset(y: offset * -0.5)
            }
        }
    }
}
