import Foundation

// Enumeration defining the options available in the side menu
enum SideMenuOptionModel: Int, CaseIterable {
    // Defining menu options
    case dashbord
    case perfomance
    case profile
    case search
    case notifications

    // Computed property to provide the title for each menu option
    var title: String {
        switch self {
        case .dashbord:
            return "Dashboard"
        case .perfomance:
            return "Performance"
        case .profile:
            return "Profile"
        case .search:
            return "Search"
        case .notifications:
            return "Notifications"
        }
    }

    // Computed property to provide the image name for each menu option
    var imageName: String {
        switch self {
        case .dashbord:
            return "menucard.fill"  // Image for dashboard option
        case .perfomance:
            return "chart.bar"     // Image for performance option
        case .profile:
            return "person"        // Image for profile option
        case .search:
            return "magnifyingglass"  // Image for search option
        case .notifications:
            return "bell"         // Image for notifications option
        }
    }
}

// Extension to make SideMenuOptionModel identifiable using its raw value
extension SideMenuOptionModel: Identifiable {
    var id: Int {
        return self.rawValue
    }
}
