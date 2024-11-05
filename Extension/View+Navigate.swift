//
//  Created by Marcelo de Araújo


import SwiftUI

extension View {

    func navigate<NewView: View>(to view: NewView,
                                 when binding: Binding<Bool>,
                                 horSizeClass: UserInterfaceSizeClass?) -> some View {
        NavigationStack {
            NavigationLink(value: 0) { // `value` is not used, and may cause a negligible (32 Byte) memory leak
                self // tapping this sets off the link
                    .navigationBarHidden(true)
            }
            .navigationDestination(isPresented: binding) {
                view
                    .navigationBarBackButtonHidden(hideBackButton(horSizeClass: horSizeClass))
            }
        }
    }

    func hideBackButton(horSizeClass: UserInterfaceSizeClass?) -> Bool {
        guard horSizeClass != nil else { return true } // don't know
        return horSizeClass == UserInterfaceSizeClass.compact // .regular on iPad and iPhone 14 Plus or Pro Max
    }

}
