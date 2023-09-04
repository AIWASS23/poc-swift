import SwiftUI

struct HeaderViewRegular: View {
    
    let title:String
    let description:String?
    let iconName:String?
    
    
    var body: some View{
        VStack(alignment: .leading){
            Text(title)
                .font(.largeTitle)
                .fontWeight(.semibold)
            if let description = description{
                Text(description)
                    .font(.callout)
            }
            
            if let iconName = iconName{
                Image(systemName: iconName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 20,height: 20)
            }
            
            RoundedRectangle(cornerRadius: 10)
                .frame(height: 2)
        }
        .frame(width: .infinity,alignment: .leading)
        .padding()
    }
}

struct HeaderViewGeneric <Content:View>: View {
    
    let title: String
    
    let content:Content
    
    init(title: String,content:Content) {
        self.title = title
        self.content = content
    }
    
    init(title:String,@ViewBuilder content: () -> Content){
        self.title = title
        self.content = content()
    }
    
    var body: some View{
        VStack(alignment: .leading){
            Text(title)
                .font(.largeTitle)
                .fontWeight(.semibold)
            content
            RoundedRectangle(cornerRadius: 10)
                .frame(height: 2)
        }
        .frame(maxWidth: .infinity,alignment: .leading)
        .padding()
    }
}


struct CustomHstack <Content:View>: View {
    
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View{
        HStack{
            content
        }
    }
}

struct ContentView: View {
    var body: some View {
        VStack{
            HeaderViewRegular(title: "Title 1", description: "Hello", iconName: "flame.fill")
            HeaderViewRegular(title: "Title 2", description: nil, iconName: nil)
            HeaderViewGeneric(title: "Generic View 1", content: Text("Generic Text"))
            HeaderViewGeneric(title: "Generic View 2", content: Image(systemName: "heart.fill"))
            HeaderViewGeneric(title: "Generci View 3") {
                HStack{
                    Text("Flame")
                    Image(systemName: "flame.fill")
                }
            }
            HeaderViewGeneric(title: "Generic View 4") {
                HStack{
                    Text("Bold")
                    Image(systemName: "bolt.fill")
                }
            }
            HeaderViewGeneric(title: "Generic View 5") {
                CustomHstack {
                    Text("Stack")
                    Image(systemName: "heart.fill")
                }
            }
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
