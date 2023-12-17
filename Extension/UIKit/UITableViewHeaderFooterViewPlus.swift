import UIKit

extension UITableViewHeaderFooterView {
    
    enum Associated {
        static var tableView = UUID()
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

extension UITableViewHeaderFooterView {
    static func registerFor(_ tableView: UITableView) {
        tableView.register(self, forHeaderFooterViewReuseIdentifier: reuseId)
    }
    static func dequeueReusableHeaderFooterView(from tableView: UITableView) -> Self? {
        tableView.dequeueReusableHeaderFooterView(withIdentifier: reuseId) as? Self
    }
}
