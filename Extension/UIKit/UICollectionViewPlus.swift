import UIKit

extension UICollectionReusableView {
	enum SupplementaryViewKind {
		case header
		case footer
        case custom(String)
		var raw: String {
            switch self {
            case .header: return UICollectionView.elementKindSectionHeader
            case .footer: return UICollectionView.elementKindSectionFooter
            case .custom(let kind): return kind
            }
		}
        init(rawValue: String) {
            if rawValue == UICollectionView.elementKindSectionHeader {
                self = .header
            } else if rawValue == UICollectionView.elementKindSectionFooter {
                self = .footer
            } else {
                self = .custom(rawValue)
            }
        }
	}
	static func registerFor(_ collectionView: UICollectionView, kind: SupplementaryViewKind) {
		collectionView.register(self, forSupplementaryViewOfKind: kind.raw, withReuseIdentifier: Self.reuseId)
	}
	static func dequeReusableSupplementaryView(from collectionView: UICollectionView, kind: SupplementaryViewKind, indexPath: IndexPath) -> Self {
        collectionView.dequeueReusableSupplementaryView(ofKind: kind.raw, withReuseIdentifier: Self.reuseId, for: indexPath) as! Self
	}
}

extension UICollectionViewCell {
	static func registerFor(_ collectionView: UICollectionView) {
		collectionView.register(self, forCellWithReuseIdentifier: reuseId)
	}
	static func dequeueReusableCell(from collectionView: UICollectionView, indexPath: IndexPath) -> Self {
		collectionView.dequeueReusableCell(withReuseIdentifier: Self.reuseId, for: indexPath) as! Self
	}
}


extension UICollectionViewFlowLayout {
    
    
    func itemSizeAt(_ indexPath: IndexPath) -> CGSize {
        guard let collectionView else { return .zero }
        guard let delegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout else { return itemSize }
        return delegate.collectionView?(collectionView, layout: self, sizeForItemAt: indexPath) ?? itemSize
    }
    
    func sectionInsetsAt(_ indexPath: IndexPath) -> UIEdgeInsets {
        guard let collectionView else { return sectionInset }
        guard let delegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout else { return sectionInset }
        return delegate.collectionView?(collectionView, layout: self, insetForSectionAt: indexPath.section) ?? sectionInset
    }
    
    func minimumInteritemSpacingForSectionAt(_ indexPath: IndexPath) -> CGFloat {
        guard let collectionView else { return minimumInteritemSpacing }
        guard let delegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout else { return minimumInteritemSpacing }
        return delegate.collectionView?(collectionView, layout: self, minimumInteritemSpacingForSectionAt: indexPath.section) ?? minimumInteritemSpacing
    }
    
    func minimumLineSpacingForSectionAt(_ indexPath: IndexPath) -> CGFloat {
        guard let collectionView else { return minimumLineSpacing }
        guard let delegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout else { return minimumLineSpacing }
        return delegate.collectionView?(collectionView, layout: self, minimumLineSpacingForSectionAt: indexPath.section) ?? minimumLineSpacing
    }
}

extension UICollectionView {
    
    func reloadItem(at indexPath: IndexPath) {
        reloadItems(at: [indexPath])
    }
    
    func isAllItemSelectedInSection(_ section: Int) -> Bool {
        
        guard let selectedIndexPaths = indexPathsForSelectedItems else {
            return false
        }

        let selectedSectionIndexPaths = selectedIndexPaths.filter { indexPath in
            indexPath.section == section
        }
        return numberOfItems(inSection: section) == selectedSectionIndexPaths.count
    }
    
    var isAllItemSelected: Bool {
        
        guard let selectedIndexPaths = indexPathsForSelectedItems else {
            return false
        }
        return numberOfItems == selectedIndexPaths.count
    }
    
    var numberOfItems: Int {
        (0..<numberOfSections).reduce(0) { itemCount, section in
            itemCount + numberOfItems(inSection: section)
        }
    }
}


extension UICollectionView.ScrollPosition {
    
    static var none: UICollectionView.ScrollPosition {
        []
    }
}
