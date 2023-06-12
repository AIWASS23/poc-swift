import SwiftUI

struct ContentView: View {
  var body: some View {
    Link(destination: URL(string: "https://github.com/AIWASS23")!, label: {
      Label("Watch my github", systemImage: "link")
        .font(.system(size: 18).bold())
        .padding(6)
        .foregroundColor(.white)
        .background(Color.red)
        .cornerRadius(6)
    })
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

