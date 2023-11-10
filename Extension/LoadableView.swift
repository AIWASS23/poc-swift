import Foundation
import SwiftUI

public struct LoadableView<Content: View, Failure: View, Item>: View {
    
    public let loadable: Loadable<Item>
    public let content: (Item) -> Content
    public let failure: (Error) -> Failure
    
    public init(_ loadable: Loadable<Item>, @ViewBuilder content: @escaping (Item) -> Content, @ViewBuilder failure: @escaping (Error) -> Failure) {
        self.loadable = loadable
        self.content = content
        self.failure = failure
    }
    
    public var body: some View {
        if let error = loadable.error {
            failure(error)
        } else {
            content(loadable.valueOrPlaceholder)
                .shimmering(if: loadable.isLoading)
                .disabled(loadable.isLoading)
        }
    }
}
