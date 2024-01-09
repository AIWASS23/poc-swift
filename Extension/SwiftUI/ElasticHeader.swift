import Foundation
import SwiftUI

/*
a estrutura chamada ElasticScrollView em SwiftUI, que permite criar uma ScrollView com 
efeitos elásticos ao rolar o conteúdo. 

ElasticScrollView {
    // Seu conteúdo aqui
}
.elasticOffset(factor: 0.5) // Aplica um deslocamento elástico com um fator de 0.5
.elasticTopPin() // Fixa o conteúdo na parte superior durante a rolagem
.elasticScale() // Aplica um efeito de escala no conteúdo enquanto é rolado

*/
struct ScrollViewOffsetKey: EnvironmentKey {
    static let defaultValue: CGFloat = 0
}

extension EnvironmentValues {
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

struct ElasticScrollView<Content: View>: View {
    let content: Content
    let showsIndicators: Bool
    
    @State private var offset: CGFloat = 0
    
    init(showsIndicators: Bool = true, @ViewBuilder content: () -> Content) {
        self.showsIndicators = showsIndicators
        self.content = content()
    }
    
    var body: some View {
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
    }
}

extension View {
    
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
