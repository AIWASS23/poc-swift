import UIKit

extension UITableView {
	
    var shouldHideScrollBar: Bool {
        shouldHideScrollBar(at: .vertical)
    }
    
    var numberOfRows: Int {
        (0..<numberOfSections).reduce(0) { rowCount, section in
            rowCount + numberOfRows(inSection: section)
        }
    }
    
    public func selectRows(at indexPaths: [IndexPath] = [], animated: Bool = true, scrollPosition: UITableView.ScrollPosition = .none) {
        for indexPath in indexPaths {
            if let indexPathsForSelectedRows, indexPathsForSelectedRows.contains(indexPath) {
                continue
            }
            selectRow(at: indexPath, animated: animated, scrollPosition: scrollPosition)
        }
    }

    public func deselectRows(at indexPaths: [IndexPath], animated: Bool = true) {
        for indexPath in indexPaths {
            deselectRow(at: indexPath, animated: animated)
        }
    }
    
    func performAllCellSelection(_ performSelection: Bool) {
        for section in 0..<numberOfSections {
            for row in 0..<numberOfRows(inSection: section) {
                let indexPath = IndexPath(row: row, section: section)
                if performSelection {
                    _ = delegate?.tableView?(self, willSelectRowAt: indexPath)
                    selectRow(at: indexPath, animated: false, scrollPosition: .none)
                    delegate?.tableView?(self, didSelectRowAt: indexPath)
                } else {
                    _ = delegate?.tableView?(self, willDeselectRowAt: indexPath)
                    deselectRow(at: indexPath, animated: false)
                    delegate?.tableView?(self, didDeselectRowAt: indexPath)
                }
            }
        }
    }
    
	func layoutHeaderFooterViewIfNeeded() {
		if let headerView = tableHeaderView {
			let fitSize = CGSize(width: bounds.size.width, height: UIView.layoutFittingCompressedSize.height)
			let layoutSize = headerView.systemLayoutSizeFitting(fitSize)
			guard headerView.frame.size != layoutSize else { return }
			headerView.frame.size = layoutSize
			tableHeaderView = headerView
		}
		if let footerView = tableFooterView {
			let fitSize = CGSize(width: bounds.size.width, height: UIView.layoutFittingCompressedSize.height)
			let layoutSize = footerView.systemLayoutSizeFitting(fitSize)
			guard footerView.frame.size != layoutSize else { return }
			footerView.frame.size = layoutSize
			tableFooterView = footerView
		}
	}
}
