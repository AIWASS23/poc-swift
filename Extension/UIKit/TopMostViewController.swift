import UIKit

/*
 A extensão serve para encontrar o controlador de visualização mais superior na hierarquia de visualizações,
 muitas vezes referido como o "top-most view controller". Isso é útil quando você está trabalhando com pilhas de navegação,
 controladores de tabulação ou apresentando modais e precisa acessar o controlador de visualização mais alto na hierarquia.

 import UIKit

 class MainViewController: UIViewController {
     override func viewDidLoad() {
         super.viewDidLoad()

         let button = UIButton(type: .system)
         button.setTitle("Show Modal", for: .normal)
         button.addTarget(self, action: #selector(showModal), for: .touchUpInside)

         view.addSubview(button)
         button.center = view.center
     }

     @objc func showModal() {
         let modalViewController = ModalViewController()
         present(modalViewController, animated: true, completion: nil)
     }
 }

 class ModalViewController: UIViewController {
     override func viewDidLoad() {
         super.viewDidLoad()

         let closeButton = UIButton(type: .system)
         closeButton.setTitle("Close Modal", for: .normal)
         closeButton.addTarget(self, action: #selector(closeModal), for: .touchUpInside)

         view.backgroundColor = .white
         view.addSubview(closeButton)
         closeButton.center = view.center
     }

     @objc func closeModal() {
         dismiss(animated: true, completion: nil)

         // Usando a extensão para encontrar o top-most view controller no momento do fechamento do modal
         let topMostVC = self.topMostViewController()
         print("Top Most View Controller: \(topMostVC)")
     }
 }

 let mainVC = MainViewController()
 // Execute a ação de mostrar modal
 mainVC.showModal()

*/

extension UIViewController {
    func topMostViewController() -> UIViewController {
        if self.presentedViewController == nil {
            return self
        }

        if let navigation = self.presentedViewController as? UINavigationController,
           let visibleViewController = navigation.visibleViewController {
            return visibleViewController.topMostViewController()
        }

        if let tab = self.presentedViewController as? UITabBarController {
            if let selectedTab = tab.selectedViewController {
                return selectedTab.topMostViewController()
            }
            return tab.topMostViewController()
        }

        guard let presentedViewController else {
            fatalError("Couldn't find presentedViewController for \(self.self) ")
        }

        return presentedViewController.topMostViewController()
    }
}
