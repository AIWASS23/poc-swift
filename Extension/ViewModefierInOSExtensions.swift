import Foundation
import SwiftUI

@available(*, deprecated, message: "This extension will be removed in a future build.")
enum OperatingSystem {
    case macOS
    case iOS
    case tvOS
    case watchOS

    // MARK: - Static Constants
    #if os(macOS)
    static let current = macOS
    #elseif os(iOS)
    static let current = iOS
    #elseif os(tvOS)
    static let current = tvOS
    #elseif os(watchOS)
    static let current = watchOS
    #else
    #error("Unsupported platform")
    #endif
}

@available(*, deprecated, message: "This extension will be removed in a future build.")
extension View {
    
    /**
    Aplique modificadores condicionalmente dependendo do sistema operacional de destino.

    Exemplo:
    ```swift
    struct ContentView: View {
        var body: some View {
            Text("Unicorn")
                .font(.system(size: 10))
                .ifOS(.macOS, .tvOS) {
                    $0.font(.system(size: 20))
                }
        }
    }
    ```
        - Parâmetro OperatingSystems: Uma lista de sistemas operacionais onde o modificador fornecido deve ser aplicado.
        - Modificador de parâmetro: o modificador a ser aplicado condicionalmente à visualização.
    */
    @available(*, deprecated, message: "This function will be removed in a future build.")
    @ViewBuilder
    public func ifOS<Content: View> (
        _ operatingSystems: OperatingSystem...,
        modifier: (Self) -> Content
    ) -> some View {
        if operatingSystems.contains(OperatingSystem.current) {
            modifier(self)
        } else {
            self
        }
    }
}
