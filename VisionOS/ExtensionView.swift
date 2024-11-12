#if os(visionOS)

import SwiftUI

extension View {
    func windowGeometryPreferences(
        size: CGSize? = nil, 
        minimumSize: CGSize? = nil,
        maximumSize: CGSize? = nil, 
        resizingRestrictions: UIWindowScene.ResizingRestrictions
    ) -> some View {
            let geometryPreferences = UIWindowScene.GeometryPreferences.Vision(
                size: size, 
                minimumSize: minimumSize, 
                maximumSize: maximumSize, 
                resizingRestrictions: resizingRestrictions
            )
            return modifier(WindowGeometryPreferencesViewModifier(geometryPreferences: geometryPreferences))
    }

    func windowGeometryPreferences(
        size: CGSize? = nil, 
        minimumSize: CGSize? = nil, 
        maximumSize: CGSize? = nil
    ) -> some View {
            let geometryPreferences = UIWindowScene.GeometryPreferences.Vision(
                size: size, minimumSize: 
                minimumSize, maximumSize: 
                maximumSize, resizingRestrictions: nil
            )
            return modifier(WindowGeometryPreferencesViewModifier(geometryPreferences: geometryPreferences))
    }

}

struct WindowGeometryPreferencesViewModifier: ViewModifier {
    let geometryPreferences: UIWindowScene.GeometryPreferences.Vision
    func body(content: Content) -> some View {
        WindowGeometryPreferencesView(geometryPreferences: geometryPreferences, content: {
            content
        })
    }
}

struct WindowGeometryPreferencesView<Content>: UIViewControllerRepresentable where Content: View {
    let geometryPreferences: UIWindowScene.GeometryPreferences.Vision
    let content: () -> Content

    func makeUIViewController(context: Context) -> WindowGeometryPreferencesUIViewController<Content> {
        WindowGeometryPreferencesUIViewController(geometryPreferences: geometryPreferences, content: content)
    }
    func updateUIViewController(_ windowGeometryPreferencesUIViewController: WindowGeometryPreferencesUIViewController<Content>, context: Context) {
        windowGeometryPreferencesUIViewController.geometryPreferences = geometryPreferences
    }
    
}

class WindowGeometryPreferencesUIViewController<Content>: UIViewController where Content: View {
    
    var geometryPreferences: UIWindowScene.GeometryPreferences.Vision {
        didSet {
            windowGeometryPreferencesUIView?.geometryPreferences = geometryPreferences
        }
    }

    let hostingController: UIHostingController<Content>
    
    var windowGeometryPreferencesUIView: WindowGeometryPreferencesUIView? {
        return viewIfLoaded as? WindowGeometryPreferencesUIView
    }
    
    init(geometryPreferences: UIWindowScene.GeometryPreferences.Vision, content: @escaping () -> Content) {
        self.geometryPreferences = geometryPreferences
        self.hostingController = UIHostingController(rootView: content())
        
        super.init(nibName: nil, bundle: nil)
        
        addChild(hostingController)
        hostingController.view.frame = view.bounds
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
        hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = WindowGeometryPreferencesUIView(geometryPreferences: geometryPreferences)
    }
    
}

class WindowGeometryPreferencesUIView: UIView {
    
    var geometryPreferences: UIWindowScene.GeometryPreferences.Vision {
        didSet {
            requestGeometryUpdate(with: geometryPreferences)
        }
    }

    init(geometryPreferences: UIWindowScene.GeometryPreferences.Vision) {
        self.geometryPreferences = geometryPreferences
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToWindow() {
        RunLoop.main.perform {
            assert(self.window?.windowScene != nil)
            self.requestGeometryUpdate(with: self.geometryPreferences)
        }
    }
    
    func requestGeometryUpdate(with geometryPreferences: UIWindowScene.GeometryPreferences) {
        window?.windowScene?.requestGeometryUpdate(self.geometryPreferences, errorHandler: { error in
            assertionFailure("Geometry update request failed: \(error)")
        })
    }
}
#endif