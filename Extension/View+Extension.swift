import Foundation
import SwiftUI

public extension View {
    
    /// Adds a redacted effect only if a condition is met (i.e. isLoading)
    @ViewBuilder
    func redacted(reason: RedactionReasons = .placeholder, if condition: Bool) -> some View {
        if condition {
            self.redacted(reason: reason)
        } else {
            self
        }
    }
    
    /// Add's an opacity animation to the redacted effect. 'if condition' must be true for the view to become redacted.
    @ViewBuilder
    func shimmering(if condition: Bool) -> some View {
        self
            .redacted(if: condition)
            .modifier(OpacityAnimationModifier())
    }
    
    /// Updates an external binding with the view's size
    func withSizeBinding(_ size: Binding<CGSize>) -> some View {
        self.modifier(WithSizeBinding(size: size))
    }
    
    func withElasticOffsetBinding(_ offset: Binding<CGFloat>, padding: CGFloat = 0) -> some View {
        self.modifier(WithElasticOffsetBinding(offset: offset, padding: padding))
    }
}

private struct OpacityAnimationModifier: ViewModifier {
    
    @State private var opacity: Double = 0.5
    
    func body(content: Content) -> some View {
        content
            .opacity(opacity)
            .onAppear {
                let animation = Animation.easeInOut(duration: 0.3).repeatForever(autoreverses: true)
                withAnimation(animation) {
                    opacity = 1
                }
            }
    }
}

private struct SizePreferenceKey: PreferenceKey {
    typealias Value = CGSize
    
    static var defaultValue: Value = .zero
    
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue()
    }
}

private struct WithSizeBinding: ViewModifier {
    @Binding var size: CGSize
    
    func body(content: Content) -> some View {
        content
            .overlay(GeometryReader { geometry in
                Color.clear.preference(key: SizePreferenceKey.self, value: geometry.size)
            })
            .onPreferenceChange(SizePreferenceKey.self) { newSize in
                self.size = newSize
            }
    }
}

private struct ElasticOffsetPreferenceKey: PreferenceKey {
    typealias Value = CGFloat
    
    static var defaultValue: Value = .zero
    
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue()
    }
}

private struct WithElasticOffsetBinding: ViewModifier {
    @Binding var offset: CGFloat
    let padding: CGFloat
    
    func body(content: Content) -> some View {
        content
            .overlay {
                GeometryReader { geometry in
                    let offset = max(0, geometry.frame(in: .named("TopOffsetBoundingBoxView")).minY - padding)
                    Color.clear.preference(key: ElasticOffsetPreferenceKey.self, value: offset)
                }
            }
            .onPreferenceChange(ElasticOffsetPreferenceKey.self) { offset in
                self.offset = offset
            }
    }
}

