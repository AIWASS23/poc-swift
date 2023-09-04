import SwiftUI

struct CustomTabBarContainerView <Content:View>: View {
    let content: Content
    @Binding var selection:TabBarItem
    @State private var tabs:[TabBarItem] = [.home,.favorites,.messages,.profile]
    
    init(selection: Binding<TabBarItem>, @ViewBuilder content: () -> Content){
        self._selection = selection
        self.content = content()
    }
    
    var body: some View {
        ZStack(alignment: .bottom){
            content.ignoresSafeArea()
            CustomTabBarView(tabs: tabs, selection: $selection, localSelection: selection)
            
        }
        .onPreferenceChange(TabBarItemPreferenceKey.self) { value in
            self.tabs = value
        }
    }
}

//struct CustomTabBarContainerView_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomTabBarContainerView()
//    }
//}
