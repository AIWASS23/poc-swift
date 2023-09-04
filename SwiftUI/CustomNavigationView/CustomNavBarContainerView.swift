import SwiftUI

struct CustomNavBarContainerView<Content:View>: View {
    let content: Content
    @State var showBackBtn:Bool = false
    @State var title:String = ""
    @State var subTitle:String? = nil
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    var body: some View {
        VStack(spacing: 0) {
            CustomNavBarView(title: title, subtitle: subTitle, showBackBtn: showBackBtn)
            content
                .frame(maxWidth: .infinity,maxHeight: .infinity)
        }
        .onPreferenceChange(CustomNavBarTitlePreferenceKey.self) { newValue in
            title = newValue
        }
        
        .onPreferenceChange(CustomNavBarSubtitlePreferenceKey.self) { newValue in
            subTitle = newValue
        }
        .onPreferenceChange(CustomNavBarBackButtonHiddenPreferenceKey.self) { newValue in
            showBackBtn = !newValue
        }
    }
}

//struct CustomNavBarContainerView_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomNavBarContainerView()
//    }
//}
