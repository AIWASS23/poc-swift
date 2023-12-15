
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
