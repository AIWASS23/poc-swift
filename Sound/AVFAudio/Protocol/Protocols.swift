import Foundation
import UIKit

public protocol SelectBook {
    func didSelect<Book>(book: Book, selectedView: UIView)

    /*
        Define um protocolo com um método didSelect que espera receber um objeto do tipo genérico 
        Book e uma UIView selecionada.
    */
}

public protocol CircleButtonProtocol {
    func readAction(selectedView: UIView)
    func playAction(selectedView: UIView)

    /*
        Define um protocolo com dois métodos, readAction e playAction, que esperam receber uma 
        UIView selecionada.
    */
}

public protocol SettingViews {
    func setupSubviews()
    func setupConstraints()

    /*
        Define um protocolo com dois métodos, setupSubviews e setupConstraints, que devem ser 
        implementados por uma classe ou struct que deseja criar e posicionar subviews de uma tela. 
        Esses métodos são comuns em telas que possuem elementos visuais complexos.
    */
}

protocol IncrementAndDecrementProtocol {
    func increment()
    func decrement()

    /*
        Define um protocolo com dois métodos, increment e decrement, que devem ser implementados por 
        uma classe ou struct que deseja ter a funcionalidade de incrementar e decrementar um valor.
    */
}

extension SettingViews {
    func buildLayoutView() {
        setupSubviews()
        setupConstraints()
    }

    /*
        Define uma extensão que adiciona um método buildLayoutView ao protocolo SettingViews. 
        Esse método chama os métodos setupSubviews e setupConstraints, permitindo que a classe ou 
        struct que implementa esse protocolo possa criar e posicionar subviews de forma simplificada.
    */
}