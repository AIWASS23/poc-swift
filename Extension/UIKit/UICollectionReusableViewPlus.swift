import UIKit

extension UICollectionReusableView {
    
    enum Associated {
        static var collectionView = UUID()
    }
    
    var inferredIndexPath: IndexPath? {
        collectionView?.indexPathForItem(at: center)
    }
    
    var collectionView: UICollectionView? {
        get {
            collectionView(UICollectionView.self)
        }
        set {
            setAssociatedObject(self, &Associated.collectionView, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    func collectionView<T>(_ type: T.Type) -> T? where T: UICollectionView {
        if let existedCollectionView = getAssociatedObject(self, &Associated.collectionView) as? T {
            return existedCollectionView
        }
        let fetchCollectionView = superview(type)
        setAssociatedObject(self, &Associated.collectionView, fetchCollectionView, .OBJC_ASSOCIATION_ASSIGN)
        return fetchCollectionView
    }
}
