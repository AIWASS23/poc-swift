import UIKit

extension UIViewController {
    
    
    func dismissPresentedViewControllerIfNeeded(_ completion: SimpleCallback? = nil) {
        if let presentedViewController {
            presentedViewController.dismiss(animated: false) {
                [unowned self] in dismissPresentedViewControllerIfNeeded()
            }
        } else {
            dismiss(animated: true, completion: completion)
        }
    }
    
    func targetNavigation<T>(_ navigationType: T.Type) -> T? where T: UINavigationController {
        if let tab = self as? UITabBarController {
            func matches(controller: UIViewController) -> Bool {
                controller.isMember(of: navigationType)
            }
            return tab.viewControllers?.first(where: matches) as? T
        } else if let navi = self as? T {
            return navi
        } else {
            return navigationController as? T
        }
    }
    
    func push(_ controller: UIViewController, animated: Bool = true) {
        if let navi = self as? UINavigationController {
            navi.pushViewController(controller, animated: animated)
        } else {
            navigationController?.pushViewController(controller, animated: animated)
        }
    }
    
    func embedInNavigationController<NavigationController>(_ navigationControllerType: NavigationController.Type = UINavigationController.self as! NavigationController.Type) -> NavigationController where NavigationController: UINavigationController {
        NavigationController(rootViewController: self)
    }
}

#if DEBUG
import SwiftUI

@available(iOS 13, *)
extension UIViewController {
	
	private struct Preview: UIViewControllerRepresentable {
		
		let viewController: UIViewController

		func makeUIViewController(context: Context) -> UIViewController { viewController }

		func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
	}

	var preview: some View {
		Preview(viewController: self)
	}
}
#endif
