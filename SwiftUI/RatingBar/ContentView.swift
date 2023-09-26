import SwiftUI

struct ContentView: View {
    @State private var title: String = "RatingBar"
    @State private var selected: Int = 0
    @State private var selected2: Int = 0
    @State private var selected3: Int = 0
    @State private var selected4: Int = 0
    
    var body: some View {
        VStack(spacing: 64) {
            RatingBar(selected: $selected) {
                title = "Rating: \($0)"
            }
            
            RatingBar(
                systemImage: "sun.max.fill",
                spacing: 16,
                color: .multi([.yellow, .orange, .red]),
                selected: $selected2
            )
            
            RatingBar(
                systemImage: "snow",
                font: .system(size: 60),
                color: .multi([.cyan, .blue]),
                selected: $selected3
            )
            
            RatingBar(
                systemImage: "heart.fill",
                elements: 10,
                font: .title,
                color: .single(.red),
                selected: $selected4
            )
        }
        .navigationTitle(title)
    }
    
    private func showRating(_ selected: Int) {
        title = "Rating is \(selected.formatted())"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContentView()
        }
    }
}
