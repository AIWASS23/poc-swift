import UIKit

/*
 A extensão serve para encontrar o controlador de visualização (view controller) pai ao qual a UIView pertence.

 import UIKit

 class CustomViewController: UIViewController {
     override func viewDidLoad() {
         super.viewDidLoad()

         let customView = CustomView()
         view.addSubview(customView)

         if let parentVC = customView.parentViewController {
             print("Parent View Controller: \(parentVC)")
         } else {
             print("No parent view controller found.")
         }
     }
 }

 class CustomView: UIView {}

 let customVC = CustomViewController()
 // Output: Parent View Controller: CustomViewController

*/

extension UIView {
    var parentViewController: UIViewController? {
        sequence(first: self) {
            $0.next
        }
        .first { $0 is UIViewController } as? UIViewController
    }
}
