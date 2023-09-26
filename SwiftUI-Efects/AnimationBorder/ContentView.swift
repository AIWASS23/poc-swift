import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 50) {
            AnimationBorder {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(.black)
                    .frame(width: 300, height: 100)
            }
            
            AnimationBorder(
                lineWidth: 10,
                cornerRadius: 200,
                colors: [.green, .cyan, .blue]
            ) {
                Circle()
                    .foregroundColor(.black)
                    .frame(width: 150, height: 150)
            }
            
            AnimationBorder(
                cornerRadius: 200,
                speed: 2,
                colors: [.pink, .purple, .indigo]
            ) {
                Capsule(style: .circular)
                    .foregroundColor(.black)
                    .frame(width: 300, height: 100)
            }
            
            Button(action: {}) {
                AnimationBorder(
                    lineWidth: 3,
                    speed: 0.75
                ) {
                    Text("Say Hello")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .frame(width: 300, height: 75)
                }
            }
        }
        .navigationTitle("AnimationBorder")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContentView()
                .preferredColorScheme(.dark)
        }
    }
}
