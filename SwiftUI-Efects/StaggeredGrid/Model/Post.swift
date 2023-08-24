
import SwiftUI

struct Post: Identifiable,Hashable {
    var id = UUID().uuidString
    var imageURL: String
}
