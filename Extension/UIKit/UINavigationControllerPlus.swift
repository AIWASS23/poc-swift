import UIKit

extension UINavigationController {
    
    convenience init(@ArrayBuilder<UIViewController> _ controllersBuilder: () -> [UIViewController]) {
        self.init()
        setViewControllers(controllersBuilder(), animated: false)
    }
    
    func refillNavigationStack(_ newRootController: UIViewController, animated: Bool = true) {
        setViewControllers([newRootController], animated: animated)
    }
    
    func replaceTopViewController(_ newController: UIViewController, animated: Bool = true) {
        var tempControllers = viewControllers
        if tempControllers.first.isValid {
            tempControllers.removeFirst()
        }
        tempControllers.insert(newController, at: 0)
        setViewControllers(tempControllers, animated: animated)
    }
}
