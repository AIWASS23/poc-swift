import SwiftUI

struct ScrollViewPreferenceKey: View {
    let title:String = "Scroll View"
    @State private var scrollOffset:CGFloat = 0
    var body: some View {
        ScrollView{
            VStack{
                titleLayer
                    .opacity(Double(scrollOffset) / 63.0)
                    .onScrollOffsetChange { offset in
                        scrollOffset = offset
                    }
                contentLayer
            }
            .padding()
        }
        .overlay(Text("\(scrollOffset)"))
        .overlay(naviLayer.opacity(scrollOffset < 40 ? 1.0 : 0.0),alignment: .top)
        
    }
}

struct ScrollViewPreferenceKey_Previews: PreviewProvider {
    static var previews: some View {
        ScrollViewPreferenceKey()
    }
}


extension ScrollViewPreferenceKey {
    
    private var titleLayer: some View{
        Text(title)
            .font(.largeTitle)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity,alignment: .leading)
    }
    
    private var contentLayer: some View{
        ForEach(0..<100){ _ in
            RoundedRectangle(cornerRadius: 10)
                .fill(.red.gradient)
                .frame(width: 300,height: 200)
        }
    }
    
    private var naviLayer: some View{
        Text("Overlay Title")
            .font(.headline)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity)
            .frame(height: 55)
    }
}

extension View{
    func onScrollOffsetChange(action: @escaping (_ offset: CGFloat) -> Void) -> some View{
        self
            .background(
                GeometryReader{ geo in
                   Text("")
                        .preference(key: scrollOffsetPreferenceKey.self, value: geo.frame(in: .global).minY)
                }
            )
            .onPreferenceChange(scrollOffsetPreferenceKey.self){ value in
                action(value)
            }
    }
}

struct scrollOffsetPreferenceKey: PreferenceKey{
    static var defaultValue: CGFloat = .zero
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
