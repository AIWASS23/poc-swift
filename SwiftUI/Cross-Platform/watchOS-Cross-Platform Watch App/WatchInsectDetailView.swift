
import SwiftUI

struct WatchInsectDetailView: View {
    let insect:Insect
    var body: some View {
        VStack{
            Text(insect.name)
            Image(insect.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(Circle())
            HStack{
                Text("Habitat")
                Text(insect.habitat)
            }
        }
    }
}

struct WatchInsectDetailView_Previews: PreviewProvider {
    static var previews: some View {
        WatchInsectDetailView(insect: testInsect)
    }
}
