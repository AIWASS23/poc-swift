import UIKit

/*
Este CoordinatorViewController fornece uma maneira consistente de gerenciar a navegação e interações entre 
os diferentes controladores de exibição no aplicativo, mantendo uma estreita relação com o Coordinator para 
manipular as transições de tela e o objeto compartilhado entre eles.
*/

class CoordinatorViewController<SharedObjectType>: UIViewController {
    var coordinator: Coordinator<SharedObjectType>!
    var sharedObject: SharedObjectType!

    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        if parent == nil {
            self.coordinator.pop()
        }
    }
}