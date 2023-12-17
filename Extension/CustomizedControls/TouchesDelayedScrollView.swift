import UIKit

class TouchesDelayedScrollView: UIScrollView {
	
    var doBlockScrollWhenHitUIControls = true
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let receiver = super.hitTest(point, with: event)
        if doBlockScrollWhenHitUIControls {
            let isUIControl = receiver?.isKind(of: UIControl.self) ?? false
            if isUIControl {
                isScrollEnabled = false
            } else {
                isScrollEnabled = true
            }
        }
        return receiver
    }
    
	override func touchesShouldCancel(in view: UIView) -> Bool {
		if view.isKind(of: UIControl.self) {
			return true
		}
		return super.touchesShouldCancel(in: view)
	}
}
