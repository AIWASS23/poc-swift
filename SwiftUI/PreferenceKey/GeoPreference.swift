import SwiftUI

struct GeoPreference: View {
    
    @State private var rectSize:CGSize = .zero
    
    var body: some View {
        VStack{
            Spacer()
            Text("Hello Geo..!")
                .font(.headline)
                .frame(width: rectSize.width,height: rectSize.height)
                .background(.red.gradient)
            Spacer()
            HStack{
                Rectangle()
                GeometryReader { geo in
                    Rectangle()
                        .updateSizeFromPreference(size: geo.size)
                        
                }
                Rectangle()
            }
            .frame(height: 55)
        }
        .onPreferenceChange(CustomGeoPreferenceKey.self) { value in
            rectSize = value
        }
    }
}

struct CustomGeoPreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

extension View {
    
    func updateSizeFromPreference(size: CGSize) -> some View{
        self
            .preference(key: CustomGeoPreferenceKey.self,value: size)
    }
}

struct GeoPreference_Previews: PreviewProvider {
    static var previews: some View {
        GeoPreference()
    }
}
