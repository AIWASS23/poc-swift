import UIKit

fileprivate typealias FirstResponderHandoff = (UIResponder) -> Void

extension UIResponder {
    enum Associated {
        static var parentController = UUID()
    }
}

extension UIResponder {
	
    
    var associatedParentController: UIViewController? {
        if let controller = getAssociatedObject(self, &Associated.parentController) as? UIViewController {
            return controller
        }
        let fetchedController = parentController(UIViewController.self)
        setAssociatedObject(self, &Associated.parentController, fetchedController, .OBJC_ASSOCIATION_ASSIGN)
        return fetchedController
    }
    
	func parentController<Controller: UIViewController>(_ type: Controller.Type) -> Controller? {
		var nextResponder = next
		while let controller = nextResponder {
			if let valid = controller as? Controller {
				return valid
			}
			nextResponder = controller.next
		}
		return nextResponder as? Controller
	}
	
	func parentView<View: UIView>(_ type: View.Type) -> View? {
		var nextResponder = next
		while let superView = nextResponder {
			if let valid = superView as? View {
				return valid
			}
			nextResponder = superView.next
		}
		return nextResponder as? View
	}
    
    static var firstResponderView: UIView? {
        firstResponder as? UIView
    }
    
   
    static var firstResponder: UIResponder? {
        
        var _firstResponder: UIResponder?
        
        let reportAsFirstHandler: FirstResponderHandoff = { responder in
            _firstResponder = responder
        }
        
        UIApplication.shared.sendAction(#selector(reportAsFirst), to: nil, from: reportAsFirstHandler, for: nil)
        
        return _firstResponder
    }
    
    @objc fileprivate func reportAsFirst(_ sender: Any) {
        if let handoff = sender as? FirstResponderHandoff {
            handoff(self)
        }
    }
}
