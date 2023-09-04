import SwiftUI

struct MatchedGeo2: View {
    let categories: [String] = ["Home", "Popular", "Saved"]
    @State private var selected:String = ""
    @Namespace private var nameSpace2
    var body: some View {
        HStack{
            ForEach(categories, id: \.self) { categorie in
                ZStack(alignment: .bottom) {
                    if selected == categorie{
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.green)
                            .matchedGeometryEffect(id: "category_background", in: nameSpace2)
                            .frame(width: 35,height: 2)
                            .offset(y:10)
                    }
                    Text(categorie)
                        .foregroundColor(selected == categorie ? .green : .black)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 55)
                .onTapGesture {
                    withAnimation(.spring()){
                        selected = categorie
                    }
                }
            }
        }
    }
}

struct MatchedGeo2_Previews: PreviewProvider {
    static var previews: some View {
        MatchedGeo2()
    }
}
