import Foundation
import SwiftUI


struct CustomNavBarTitlePreferenceKey: PreferenceKey {
    static var defaultValue: String = ""
    
    static func reduce(value: inout String, nextValue: () -> String) {
        value = nextValue()
    }
}

struct CustomNavBarSubtitlePreferenceKey:PreferenceKey {
    static var defaultValue: String? = nil
    
    static func reduce(value: inout String?, nextValue: () -> String?) {
        value = nextValue()
    }
    
}

struct CustomNavBarBackButtonHiddenPreferenceKey:PreferenceKey {
    static var defaultValue: Bool = false
    
    static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value = nextValue()
    }
}


extension View{
    
    func customNavigationTitle(_ title:String) -> some View {
        preference(key: CustomNavBarTitlePreferenceKey.self,value: title)
    }
    
    func customNavigationSubtitle(_ subTitle:String?) -> some View{
        preference(key: CustomNavBarSubtitlePreferenceKey.self,value: subTitle)
    }
    
    func customNavigationBarBackButtonHidden(_ hidden:Bool) -> some View{
        preference(key: CustomNavBarBackButtonHiddenPreferenceKey.self,value: hidden)
    }
    
    func customNavigationItems(_ title:String = "",_ subTitle:String? = nil,_ hidden:Bool = false) -> some View{
        self
        .customNavigationTitle(title)
        .customNavigationSubtitle(subTitle)
        .customNavigationBarBackButtonHidden(hidden)
    }
}
