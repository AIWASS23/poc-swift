
import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack{
            ForEach(FaceParts.allCases){
                DraggableView(location: $0.defaultLocation, imageName: $0.imageName)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
