import UIKit

/*
Esse código cria uma estrutura genérica de navegação entre controladores de exibição em um aplicativo iOS, 
permitindo a navegação para a frente, para trás e até a raiz da pilha de forma genérica e controlada, além 
de gerenciar um objeto compartilhado entre esses controladores.
*/

protocol CoordinatorDelegate: NSObjectProtocol {
    func coordinatorDidReachFirstViewController()
    func coordinatorDidReachLastViewController()
}

class Coordinator<SharedObjectType>: NSObject {
    private(set) var navigationController: UINavigationController
    private(set) var sharedObject: SharedObjectType
    private(set) var currentIndex: Int = -1
    private(set) var coordinatorTypes: [CoordinatorViewController<SharedObjectType>.Type] = []
    
    weak var delegate: CoordinatorDelegate?
    
    init(navigationControllerType: UINavigationController.Type, sharedObject: SharedObjectType) {
        self.navigationController = navigationControllerType.init(nibName: nil, bundle: nil)
        self.sharedObject = sharedObject
        super.init()
    }
    
    func push() {
        guard currentIndex <= coordinatorTypes.count - 2 else {
            debugPrint("you have reached the last viewController")
            delegate?.coordinatorDidReachLastViewController()
            return
        }
        
        increaseCurrentIndex()
        
        let currentCoordinatorType = self.coordinatorTypes[currentIndex]
        let currentCoordinator = currentCoordinatorType.init()
        self.push(to: currentCoordinator)
    }
    //
    func push(to viewController: CoordinatorViewController<SharedObjectType>) {
        viewController.coordinator = self
        viewController.sharedObject = self.sharedObject
        navigationController.pushViewController(viewController, animated: true)
    }
    //
    func pop() {
        guard currentIndex > 0 else {
            debugPrint("you reached the first viewController")
            delegate?.coordinatorDidReachFirstViewController()
            return
        }
        decreaseCurrentIndex()
    }
    
    func popToRoot() {
        currentIndex = 0
        navigationController.popToRootViewController(animated: true)
    }

    func setCoordinatorTypes(_ coordinatorTypes: [CoordinatorViewController<SharedObjectType>.Type]) {
        self.coordinatorTypes = coordinatorTypes
        push()
    }
    
    private func increaseCurrentIndex() {
        self.currentIndex = currentIndex == coordinatorTypes.count - 1 ? currentIndex : currentIndex + 1
    }

    private func decreaseCurrentIndex() {
        currentIndex -= 1
    }
}
