
#if os(iOS) || os(tvOS)

/*

Essa extensão fornece um atalho conveniente para obter a cena em primeiro plano e ativa, 
caso a aplicação tenha múltiplas cenas e se deseje interagir ou realizar operações em uma 
cena específica.

*/
import Foundation
import UIKit

extension UIApplication {
    var foregroundActiveScene: UIWindowScene? {
        connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
    }
}
#endif

@available(iOS 13.0, *)
extension UIApplication {
    var mainWindow: UIWindow? {
        connectedScenes
            .compactMap {
                $0 as? UIWindowScene
            }
            .flatMap {
                $0.windows
            }
            .first {
                $0.isKeyWindow
            }
    }
}

extension UIApplication {
    // This function returns the topmost view controller by starting from the root view controller of the key window.
    @available(iOS 13.0, *)
    func topMostViewController() -> UIViewController? {
        return self.mainWindow?.rootViewController?.topMostViewController()
    }
}

