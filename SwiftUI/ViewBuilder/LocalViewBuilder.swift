import SwiftUI

struct LocalViewBuilder: View {
    
    @State private var type: ViewType = .one
    
    var body: some View {
        VStack{
            buttonView
                .padding()
            headerSection
        }
    }
    
    
    private var buttonView: some View {
        VStack {
            Button {
                type = .one
            } label: {
                Text("One")
                    .withCustomModifier()
            }
            .withCustomStyle()

            Button {
                type = .two
            } label: {
                Text("Two")
                    .withCustomModifier()
            }
            .withCustomStyle()

            Button {
                type = .three
            } label: {
                Text("Three")
                    .withCustomModifier()
            }
            .withCustomStyle()
        }
    }
    
    @ViewBuilder private var headerSection: some View {
        switch type {
        case .one:
            viewOne
        case .two:
            viewTwo
        case .three:
            viewThree
        }
    }
    
    private var viewOne: some View {
        Text("View One")
    }
    
    private var viewTwo: some View{
        HStack{
            Text("View Two")
            Image(systemName: "flame.fill")
        }
    }
    
    private var viewThree: some View{
        Text("View Three")
    }
}




struct LocalViewBuilder_Previews: PreviewProvider {
    static var previews: some View {
        LocalViewBuilder()
    }
}

enum ViewType {
    case one
    case two
    case three
}
