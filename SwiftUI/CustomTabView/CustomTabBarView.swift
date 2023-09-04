import SwiftUI

struct CustomTabBarView: View {

    let tabs:[TabBarItem]
    @Namespace private var nameSpace
    @Binding var selection:TabBarItem
    @State  var localSelection:TabBarItem
    var body: some View {
        tabBarVersion2
            .onChange(of: selection) { newValue in
                withAnimation(.easeInOut){
                    localSelection = newValue
                }
            }
    }
}


extension CustomTabBarView {
    private func tabView(tab: TabBarItem) -> some View{
        HStack{
            Image(systemName: tab.iconName)
                .font(.subheadline)
            Text(tab.title)
                .font(.system(size: 10,weight: .semibold,design: .rounded))
        }
        .foregroundColor(localSelection == tab ? tab.color : .gray)
        .padding(.vertical,8)
        .frame(maxWidth: .infinity)
        .background(localSelection == tab ? tab.color.opacity(0.2 ) : .clear)
        .cornerRadius(10)
    }
    
    private func switchTab(tab: TabBarItem){
        selection = tab
    }
    
    private func switchTabWithAnimation(tab: TabBarItem){
        withAnimation(.easeInOut){
            selection = tab
        }
    }
    
    private var tabVersion1: some View{
        HStack{
            ForEach(tabs,id: \.self) { tab in
                tabView(tab: tab)
                    .onTapGesture {
                        switchTab(tab: tab)
                    }
            }
        }
        .padding(6)
        .background(Color.white.ignoresSafeArea(edges: .bottom))
    }
}

extension CustomTabBarView{
    
    private func tabView2(tab:TabBarItem) -> some View{
        VStack{
            Image(systemName: tab.iconName)
                .font(.subheadline)
            Text(tab.title)
                .font(.system(size: 10,weight: .semibold,design: .rounded))
        }
        .foregroundColor(localSelection == tab ? tab.color : .gray)
        .padding(.vertical,8)
        .frame(maxWidth: .infinity)
        .background(
            ZStack{
                if localSelection == tab{
                    RoundedRectangle(cornerRadius: 10)
                        .fill(tab.color.opacity(0.2))
                        .matchedGeometryEffect(id: "background", in: nameSpace)
                }
            }
        )
    }
    
    private var tabBarVersion2: some View{
        HStack{
            ForEach(tabs,id: \.self) { tab in
                tabView2(tab: tab)
                    .onTapGesture {
                        switchTab(tab: tab)
                    }
            }
        }
        .padding(6)
        .background {
            Color.white.ignoresSafeArea(edges: .bottom)
        }
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.3), radius: 10,x: 0,y: 5)
        .padding(.horizontal)
    }
}

