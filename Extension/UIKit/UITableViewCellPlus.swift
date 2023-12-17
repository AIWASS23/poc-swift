import UIKit

extension UITableViewCell {
    
    enum Associated {
        static var tableView = UUID()
    }
    
    var inferredIndexPath: IndexPath? {
        tableView?.indexPath(for: self)
    }
    
    var tableView: UITableView? {
        get {
            tableView(UITableView.self)
        }
        set {
            setAssociatedObject(self, &Associated.tableView, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    func tableView<T>(_ type: T.Type) -> T? where T: UITableView {
        if let existedTableView = getAssociatedObject(self, &Associated.tableView) as? T {
            return existedTableView
        }
        let fetchTableView = superview(type)
        setAssociatedObject(self, &Associated.tableView, fetchTableView, .OBJC_ASSOCIATION_ASSIGN)
        return fetchTableView
    }
}

extension UITableViewCell {
    static func registerFor(_ tableView: UITableView) {
        tableView.register(self, forCellReuseIdentifier: reuseId)
    }
    static func dequeueReusableCell(from tableView: UITableView, indexPath: IndexPath) -> Self {
        tableView.dequeueReusableCell(withIdentifier: Self.reuseId, for: indexPath) as! Self
    }
}
