import Foundation
import SwiftUI


enum TabBarItem: Hashable {
    
    case home,favorites,profile,messages
    
    var iconName: String{
        switch self {
        case .home:
            return "house"
        case .favorites:
            return "heart"
        case .profile:
            return "person"
        case .messages:
            return "message"
        }
    }
    
    var title: String{
        switch self {
        case .home:
            return "home"
        case .favorites:
            return "favorites"
        case .profile:
            return "profile"
        case .messages:
            return "messages"
        }
    }
    
    var color:Color{
        switch self {
        case .home:
            return Color.red
        case .favorites:
            return Color.blue
        case .profile:
            return Color.green
        case .messages:
            return Color.orange
        }
    }
}
