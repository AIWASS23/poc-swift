import UIKit

extension UIScrollView {

    func shouldHideScrollBar(at direction: UICollectionView.ScrollDirection) -> Bool {
        switch direction {
        case .horizontal:
            return contentSize.width <= bounds.width
        case .vertical:
            return contentSize.height <= bounds.height
        @unknown default:
            assertionFailure("Unhandled condition")
            return false
        }
    }
    
}
