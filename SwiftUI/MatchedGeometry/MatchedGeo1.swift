import SwiftUI

struct MatchedGeo1: View {
    @State private var isSelected:Bool =  false
    @Namespace private var nameSpace
    
    var body: some View {
        VStack{
            if !isSelected{
                RoundedRectangle(cornerRadius: 10)
                    .fill(.thinMaterial)
                    .matchedGeometryEffect(id: "rectangle", in: nameSpace)
                    .frame(width: 100,height: 100)
            }
            Spacer()
            if isSelected{
                RoundedRectangle(cornerRadius: 10)
                    .fill(.thinMaterial)
                    .matchedGeometryEffect(id: "rectangle", in: nameSpace)
                    .frame(width: 300,height: 200)
            }
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .background(LinearGradient(colors: [.green,.blue], startPoint: .topLeading, endPoint: .bottomTrailing))
        .onTapGesture {
            withAnimation(.easeInOut){
                isSelected.toggle()
            }
        }
    }
}

struct MatchedGeo1_Previews: PreviewProvider {
    static var previews: some View {
        MatchedGeo1()
    }
}
