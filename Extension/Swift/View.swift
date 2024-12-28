import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

public extension View {
    #if canImport(UIKit)
    func hideKeyboard() {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    #endif
    
    @ViewBuilder
    func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
    
    @ViewBuilder func `if`<Content: View>(
        _ condition: Bool, transform: (Self) -> Content,
        transformElse: ((Self) -> Content)? = nil) -> some View {
           if condition {
               transform(self)
           } else {
               if let transformElse = transformElse {
                   transformElse(self)
               } else {
                   self
               }
           }
       }
    
    /// `if let` statement view modifier
    ///
    /// Example:
    ///
    ///     var color: Color?
    ///
    ///     var body: some View {
    ///         Text("Example")
    ///         .if(let: color) { $0.foregroundColor($1) }
    ///     }
    ///
    @ViewBuilder
    func `if`<Transform: View, T> (
        `let` optional: T?,
        @ViewBuilder transform: (Self, T) -> Transform
    ) -> some View {
        if let optional = optional {
            transform(self, optional)
        } else {
            self
        }
    }
    
    /// `if let else` statement view modifier
    ///
    /// Example:
    ///
    ///     var color: Color?
    ///
    ///     var body: some View {
    ///         Text("Example")
    ///         .if(let: color) {
    ///             $0.foregroundColor($1)
    ///         } else: {
    ///             $0.underline()
    ///         }
    ///
    @ViewBuilder
    func `if`<Transform: View, Fallback: View, T> (
        `let` optional: T?,
        @ViewBuilder transform: (Self, T) -> Transform,
        @ViewBuilder else fallbackTransform: (Self) -> Fallback
    ) -> some View {
        if let optional = optional {
            transform(self, optional)
        } else {
            fallbackTransform(self)
        }
    }
    
    
    /// Navigation view modifier
    ///
    /// Example:
    ///
    ///     @State private var nextScreenviewModel: ViewModel?
    ///
    ///     var body: some View {
    ///         Text("Example")
    ///         .navigation(item: $nextScreenviewModel) { NextScreenView(viewModel: $0) }
    ///     }
    ///
    func navigation<Item, Destination: View>(
        item: Binding<Item?>,
        @ViewBuilder destination: (Item) -> Destination
    ) -> some View {
        let isActive = Binding(
            get: { item.wrappedValue != nil },
            set: { value in if !value { item.wrappedValue = nil } }
        )
        return navigation(isActive: isActive) {
            item.wrappedValue.map(destination)
        }
    }
    
    /// Navigation view modifier
    ///
    /// Example:
    ///
    ///     @State private var isShowingView = false
    ///
    ///     var body: some View {
    ///         Text("Example")
    ///         .navigation(isActive: $isShowingView) { Text("Another screen") }
    ///     }
    ///
    func navigation<Destination: View>(
        isActive: Binding<Bool>,
        @ViewBuilder destination: () -> Destination
    ) -> some View {
        overlay(
            NavigationLink(
                destination: isActive.wrappedValue ? destination() : nil,
                isActive: isActive,
                label: { EmptyView() }
            )
        )
    }
    
    /// Reads view size with geometry reader
    func readSize(
        onChange: @escaping (CGSize) -> Void
    ) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
    
    /// Reads view frame with geometry reader
    func readFrame(
        space: CoordinateSpace,
        onChange: @escaping (CGRect) -> Void
    ) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: FramePreferenceKey.self, value: geometryProxy.frame(in: space))
            }
        )
            .onPreferenceChange(FramePreferenceKey.self, perform: onChange)
    }
    
    #if os(iOS)
    func cornerRadius(
        _ radius: CGFloat,
        corners: UIRectCorner
    ) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
    
    func flippedVertically() -> some View {
        self.rotation3DEffect(.degrees(180), axis: (x: 1, y: 0, z: 0))
    }
    
    func flippedHorizontally() -> some View {
        self.rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
    }
    #endif
    
    #if os(iOS)
    /// Sets navigation bar style when view appers
    ///
    /// - Warning:
    /// Use only once per navigation view
    func navigationBarStyle(
        titleTextAttributes: [NSAttributedString.Key: Any],
        largeTitleTextAttributes: [NSAttributedString.Key: Any],
        tintColor: UIColor?,
        shadowColor: UIColor?,
        backgroundColor: UIColor?,
        backButtonImage: UIImage?
    ) -> some View {
        self.modifier(
            NavAppearanceModifier(
                titleTextAttributes: titleTextAttributes,
                largeTitleTextAttributes: largeTitleTextAttributes,
                tintColor: tintColor,
                shadowColor: shadowColor,
                backgroundColor: backgroundColor,
                backImage: backButtonImage
            )
        )
    }
    #endif
    
    func handleKeyBoard() -> some View {
        modifier(HandelKeyBoard())
    }

}

public extension View {
    // Set frame width and height dynamically
    func setFrame(width: CGFloat, height: CGFloat, alignment: Alignment = .center) -> some View {
        let scalingFactor = DeviceHelper.getScalingFactor()
        return self.frame(
            width: width * scalingFactor,
            height: height * scalingFactor,
            alignment: alignment
        )
    }
    
    // Set frame height dynamically
    func setFrame(height: CGFloat, alignment: Alignment = .center) -> some View {
        let scalingFactor = DeviceHelper.getScalingFactor()
        return self.frame(height: height * scalingFactor, alignment: alignment)
    }
    
    // Set frame width dynamically
    func setFrame(width: CGFloat, alignment: Alignment = .center) -> some View {
        let scalingFactor = DeviceHelper.getScalingFactor()
        return self.frame(width: width * scalingFactor, alignment: alignment)
    }
    
    // Set corner radius dynamically
    func setCornerRadius(_ radius: CGFloat, corners: UIRectCorner = .allCorners) -> some View {
        let scalingFactor = DeviceHelper.getScalingFactor()
        return self.cornerRadius(radius * scalingFactor, corners: corners)
    }
    
    func setPadding(_ padding: CGFloat = 20) -> some View {
        self.padding(padding * DeviceHelper.getScalingFactor())
    }
    
    func setPadding(_ edges: Edge.Set = .all, _ padding: CGFloat = 20) -> some View {
        self.padding(edges, padding * DeviceHelper.getScalingFactor())
    }
}

public extension View {
    func swipe(
        up: (() -> Void)? = nil,
        down: (() -> Void)? = nil,
        left: (() -> Void)? = nil,
        right: (() -> Void)? = nil
    ) -> some View {
        return self.gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onEnded({ value in
                // Check the current layout direction
                let isRTL = UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft
                
                // Determine the swipe direction
                if value.translation.width < 0 {
                    isRTL ? right?() : left?()  // Invert left and right for RTL
                }
                if value.translation.width > 0 {
                    isRTL ? left?() : right?()  // Invert left and right for RTL
                }
                if value.translation.height < 0 { up?() }
                if value.translation.height > 0 { down?() }
            }))
    }
}


// Accessibility features extension for View
public extension View {
    /// Adds accessibility features to the view with customizable parameters.
    /// - Parameters:
    ///   - labelKey: The localization key for the accessibility label. This is **mandatory** as it provides the essential description of the element for screen readers (e.g., VoiceOver).
    ///   - hintKey: The localization key for the accessibility hint. The hint provides extra context or guidance to the user, such as "Double tap to activate" (optional).
    ///   - valueKey: The localization key for the accessibility value. This represents the current state of the element (for controls such as sliders, steppers, etc.) (optional).
    ///   - traits: Accessibility traits that define the behavior of the element. These traits help VoiceOver know how to treat the element. Defaults to an empty array.
    ///
    ///     **Common Traits**:
    ///     - `.isButton`: Marks the view as a button, letting the user know they can tap on it.
    ///     - `.isLink`: Marks the view as a link, typically used for tappable text leading to another page or section.
    ///     - `.isHeader`: Identifies the view as a header or title for a section.
    ///     - `.isImage`: Marks the view as an image, typically for decorative or illustrative content.
    ///     - `.isSelected`: Indicates that the view is in a selected state, useful for toggle buttons, lists, or radio buttons.
    ///     - `.isSummaryElement`: Used for elements that represent a summary of the content (e.g., expandable list items).
    ///     - `.isAdjustable`: Used for controls that the user can adjust, like sliders or steppers.
    ///     - `.isSearchField`: Identifies the view as a search field.
    ///     - `.isKeyboardKey`: Marks the view as a keyboard key.
    ///     - `.playsSound`: Indicates that interacting with this view will play a sound.
    ///     - `.updatesFrequently`: Used for content that changes dynamically, such as live updates.
    ///
    ///   - action: Optional action that can be triggered by accessibility features, like a custom action for a double-tap or a gesture. If no action is needed, this can be left out.
    ///
    ///     **Available Actions**:
    ///     - `.default`: Triggered by a double-tap or similar interaction. This is the most common action for interactive elements.
    ///     - `.escape`: Used for dismissing views, similar to pressing the "Back" button or closing a modal.
    ///     - `.magicTap`: A system-provided gesture that performs a common action, such as answering calls or playing/pausing media.
    /// - Returns: A view with extended accessibility features.
    func setReader(
        labelKey: String,                  // Mandatory label key for accessibility
        hintKey: String? = nil,            // Optional hint key for additional context
        valueKey: String? = nil,           // Optional value key for representing current value
        traits: AccessibilityTraits = [],   // Accessibility traits to define behavior
        actionKind: AccessibilityActionKind = .default, // Accessibility Action Kind
        action: (() -> Void)? = nil        // Optional custom action
    ) -> some View {
        // Start with the current view
        var modifiedView = self
        
        // Accessibility Label (Mandatory)
        modifiedView = modifiedView
            .accessibilityLabel(LocalizedStringKey(labelKey)) as! Self
        
        // Accessibility Hint (Optional)
        if let hintKey = hintKey {
            modifiedView = modifiedView
                .accessibilityHint(LocalizedStringKey(hintKey)) as! Self
        }
        
        // Accessibility Value (Optional)
        if let valueKey = valueKey {
            modifiedView = modifiedView
                .accessibilityValue(LocalizedStringKey(valueKey)) as! Self
        }
        
        // Accessibility Traits (Defaults to [])
        modifiedView = modifiedView.accessibilityAddTraits(traits) as! Self
        
        // Accessibility Action (Optional)
        if let action = action {
            modifiedView = modifiedView
                .accessibilityAction(actionKind, action) as! Self
        }
        
        return modifiedView
    }
}

#if os(iOS)
private struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(
        in rect: CGRect
    ) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
#endif

private struct SizePreferenceKey: PreferenceKey {
  static var defaultValue: CGSize = .zero
  static func reduce(
    value: inout CGSize,
    nextValue: () -> CGSize
  ) {}
}

private struct FramePreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(
        value: inout CGRect,
        nextValue: () -> CGRect
    ) {}
}
