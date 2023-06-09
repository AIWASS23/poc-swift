import Foundation
import SwiftUI

struct Onboard: Identifiable {
    let id: UUID
    let title: String
    let description: String
    let tag: String
    let color: Color
}

var onboardItems: [Onboard] = [
    
    Onboard(id: UUID(), title: "JBL", description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book", tag: "Headphone", color: Color(hex: 0xBBE5B2)),
    
    Onboard(id: UUID(), title: "PS5", description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley", tag: "Video Games", color: Color(hex: 0xFFC58B)),
    
    Onboard(id: UUID(), title: "Iphone", description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s", tag: "Phone", color: Color(hex: 0xB4E0FA)),
]
