import SwiftUI

struct Home: View {
    // MARK: - View Properties
    @State private var colors: [ColorValue] = [.red, .yellow, .green, .purple, .pink, .orange, .brown, .cyan, .indigo, .mint].compactMap { color -> ColorValue? in
        return .init(color: color)
    }
    @State private var activeIndex:Int = 0
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                
                RadialLayout(items: colors, id: \.id, spacing: 220) { colorValue, index, size in
                    // MARK: - Sample View
                    Circle()
                        .fill(colorValue.color.gradient)
                        .overlay {
                            Text("\(index)")
                                .fontWeight(.semibold)
                        }
                } onIndexChange: { index in
                    // MARK: -  Updating Index
                    activeIndex = index
                }
                .padding(.horizontal, -100)
                .frame(width: geometry.size.width, height: geometry.size.width / 2)
                

            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding(15)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
