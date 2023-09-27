import SwiftUI
import TipKit

struct ContentView: View {
    var images = ["newyork", "paris", "egypt", "tokyo", "sydney", "london"] // Your Image

    var favoriteTip = FavoriteTip()

    var body: some View {
        NavigationView {
            List {
                HStack {
                    cityImageView(0)
                    cityImageView(1)
                }
                .listRowSeparator(.hidden)

                HStack {
                    cityImageView(2)
                    cityImageView(3)
                }

                .listRowSeparator(.hidden)

                HStack {
                    cityImageView(4)
                    cityImageView(5)
                }
                .listRowSeparator(.hidden)

            }
            .navigationTitle("TipKit demo")

        }
        .task {
            try? Tips.configure([
                .displayFrequency(.immediate),
                .datastoreLocation(.applicationDefault)
            ])
        }
    }

    private func cityImageView(_ index: Int) -> some View {
        ZStack {
            Image(images[index])
                .resizable()
                .aspectRatio(contentMode: .fill)
                .cornerRadius(10)
                .padding(5)
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {}, label: {
                        Image(systemName: "star.circle.fill")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .aspectRatio(contentMode: .fit)
                            .foregroundStyle(Color.white)
                            .padding()
                    })
                    .popoverTip(favoriteTip, arrowEdge: .bottom, action: {_ in })
                }
                .background(Color.black.opacity(0.4))
                .cornerRadius(10)
                .padding(5)
            }
        }
    }
}

#Preview {
    ContentView()
}
