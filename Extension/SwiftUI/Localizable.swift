import UIKit
import SwiftUI

/*
Facilita a localização de textos em elementos de interface do usuário como labels, botões e campos de texto, 
permitindo que eles exibam diferentes idiomas conforme as configurações de idioma do dispositivo.
*/

protocol Localizable {
    var localize: String { get }
}

extension UILabel: Localizable {
    @IBInspectable
    var localize: String {
        get {
            text ?? ""
        } set {
            text = NSLocalizedString(newValue, comment: newValue)
        }
    }
}

extension UIButton: Localizable {
    @IBInspectable
    var localize: String {
        get {
            titleLabel?.text ?? ""
        } set {
            let string = NSLocalizedString(newValue, comment: newValue)
            setTitle(string, for: .normal)
        }
    }
}

extension UITextField: Localizable {
    @IBInspectable
    var localize: String {
        get {
            placeholder ?? ""
        } set {
            placeholder = NSLocalizedString(newValue, comment: newValue)
        }
    }
}

@available(iOS 13.0, *)
extension Text {
    init(localized key: LocalizedStringKey) {
        self.init(key)
    }
}
