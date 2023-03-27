import Foundation
import UIKit

public protocol SelectBook {
    func didSelect<Book>(book: Book, selectedView: UIView)
}

public protocol CircleButtonProtocol {
    func readAction(selectedView: UIView)
    func playAction(selectedView: UIView)
}

public protocol SettingViews {
    func setupSubviews()
    func setupConstraints()
}

protocol IncrementAndDecrementProtocol {
    func increment()
    func decrement()
}

extension SettingViews {
    func buildLayoutView() {
        setupSubviews()
        setupConstraints()
    }
}