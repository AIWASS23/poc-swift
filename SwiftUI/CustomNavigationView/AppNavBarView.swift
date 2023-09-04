import SwiftUI

struct AppNavBarView: View {
    var body: some View {
        CustomNavView {
            ZStack{
                Color.blue.opacity(0.5).ignoresSafeArea()
                CustomNavLink(destination:CustomDestinationView
                    .customNavigationTitle("Second Screen")
                    .customNavigationSubtitle("Second SubTitle")
                    .customNavigationBarBackButtonHidden(false)
                ){
                    Text("Navigate")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
            }
            .customNavigationItems("First Screen","First SubTitle",true)
        }
    }
}

extension AppNavBarView {
    
    private var CustomDestinationView: some View{
        ZStack{
            Color.green.opacity(0.5).ignoresSafeArea()
            Text("Destination")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
    }
}

struct AppNavBarView_Previews: PreviewProvider {
    static var previews: some View {
        AppNavBarView()
    }
}
