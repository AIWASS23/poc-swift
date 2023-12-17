import UIKit

extension UITouch {
    
    func offset(in view: UIView?) -> CGPoint {
        let location = location(in: view)
        let previousLocation = previousLocation(in: view)
        let offsetX = location.x - previousLocation.x
        let offsetY = location.y - previousLocation.y
        return CGPoint(x: offsetX, y: offsetY)
    }
}
