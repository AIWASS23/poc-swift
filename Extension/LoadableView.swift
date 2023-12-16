import Foundation
import SwiftUI

struct LoadableView<Content: View, Failure: View, Item>: View {
    
    let loadable: Loadable<Item>
    let content: (Item) -> Content
    let failure: (Error) -> Failure
    
    init(_ loadable: Loadable<Item>, @ViewBuilder content: @escaping (Item) -> Content, @ViewBuilder failure: @escaping (Error) -> Failure) {
        self.loadable = loadable
        self.content = content
        self.failure = failure
    }
    
    var body: some View {
        if let error = loadable.error {
            failure(error)
        } else {
            content(loadable.valueOrPlaceholder)
                .shimmering(if: loadable.isLoading)
                .disabled(loadable.isLoading)
        }
    }
}
