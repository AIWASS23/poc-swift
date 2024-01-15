import SwiftUI

struct ContentView: View {
    @State private var selectedColor: UIColor?
    static let colors: [UIColor] = [.systemRed, .systemBlue, .systemPink, .systemYellow, .systemCyan]

    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 12) {
                AsyncPhoto(id: selectedColor,
                           scaledSize: CGSize(width: 48, height: 48),
                           data: { selectedColor in
                    guard let selectedColor else { return nil }
                    return await Task.detached {
                        UIImage.filled(size: CGSize(width: 5000, height: 5000),
                                       fillColor: selectedColor).pngData()
                    }.value
                },
                           content: { image in
                    image
                        .clipShape(Circle())
                },
                           placeholder: {
                    Image(systemName: "person.crop.circle")
                        .resizable()
                })
                VStack(alignment: .leading, spacing: 8) {
                    Text("Marcelo de Araújo")
                    Text("Quero Coca-Cola")
                        .font(.caption2)
                }
            }
            .padding()
            .background(.orange, in: RoundedRectangle(cornerRadius: 8))

            Button("Reload") {
                var newColor: UIColor?
                repeat {
                    newColor = Self.colors.randomElement()!
                } while selectedColor == newColor
                selectedColor = newColor
            }
            Button("Clear") {
                selectedColor = nil
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

// Usando Cache

/*

import SwiftUI

struct ContentView: View {
    @State private var numberOfViews = 1
    @State private var selectedColor: UIColor?
    static let colors: [UIColor] = [.systemRed, .systemBlue, .systemGreen]
    
    var body: some View {
        VStack(spacing: 16) {
            List(0..<numberOfViews, id: \.self) { _ in 
                HStack(spacing: 12) {
                    AsyncPhoto(id: selectedColor,
                               scaledSize: CGSize(width: 48, height: 48),
                               data: { selectedColor in
                        guard let selectedColor else { return nil }
                        // Simulate accessing image data asynchronously
                        // In a real app we would read it from a disk or even use URLSession
                        return await Task.detached {
                            UIImage.filled(size: CGSize(width: 2000, height: 2000),
                                           fillColor: selectedColor).pngData()
                        }.value
                    },
                               content: { image in
                        image.clipShape(Circle())
                    },
                               placeholder: {
                        Image(systemName: "person.crop.circle")
                            .resizable()
                    })
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Marcelo de Araújo")
                        Text("Quero café")
                            .font(.caption2)
                    }
                }
                .padding()
                .background(.orange, in: RoundedRectangle(cornerRadius: 8))
            }
            
            Button("Reload") {
                var newColor: UIColor?
                repeat {
                    newColor = Self.colors.randomElement()!
                } while selectedColor == newColor
                selectedColor = newColor
            }
            Button("Duplicate") {
                numberOfViews += 1
            }
            Button("Clear") {
                selectedColor = nil
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}


*/