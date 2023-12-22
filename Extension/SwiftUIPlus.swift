import SwiftUI

@available(iOS 13.0, *)
extension UIEdgeInsets {
    
    var swiftUIEdgeInsets: EdgeInsets {
        EdgeInsets(top: top, leading: left, bottom: bottom, trailing: right)
    }
}

@available(iOS 13.0, *)
struct SafeAreaInsetsKey: PreferenceKey, EnvironmentKey {
    
    static var defaultValue: EdgeInsets {
        UIWindow.keyWindow?.safeAreaInsets.swiftUIEdgeInsets ?? EdgeInsets()
    }
    
    static func reduce(value: inout EdgeInsets, nextValue: () -> EdgeInsets) {
        value = nextValue()
    }
}

@available(iOS 13.0, *)
extension EnvironmentValues {
    
    var safeAreaInsets: EdgeInsets {
        self[SafeAreaInsetsKey.self]
    }
}

@available(iOS 13.0, *)
extension View {
    
    func getSafeAreaInsets(_ safeInsets: Binding<EdgeInsets>) -> some View {
        background(
            GeometryReader { proxy in
                Color.clear.preference(key: SafeAreaInsetsKey.self, value: proxy.safeAreaInsets)
            }
            .onPreferenceChange(SafeAreaInsetsKey.self) { value in
                safeInsets.wrappedValue = value
            }
        )
    }
    
    func printSafeAreaInsets(id: String) -> some View {
        background(
            GeometryReader { proxy in
                Color.clear.preference(key: SafeAreaInsetsKey.self, value: proxy.safeAreaInsets)
            }
            .onPreferenceChange(SafeAreaInsetsKey.self) { value in
                print("\(id) insets:\(value)")
            }
        )
    }
}

@available(iOS 13.0, *)
struct TestGetSafeAreaInsets: View {
    
    @Environment(\.safeAreaInsets) private var globalInsets
    
    @State var safeAreaInsets = EdgeInsets()
    
    var body: some View {
        NavigationView {
            VStack {
                Color.blue
            }
        }
        .getSafeAreaInsets($safeAreaInsets)
        .printSafeAreaInsets(id: "NavigationView")
    }
}
