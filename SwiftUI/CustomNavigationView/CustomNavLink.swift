import SwiftUI

struct CustomNavLink <Label:View,Destination:View>: View {
    let destination:Destination
    let label:Label
    
    init(destination: Destination,@ViewBuilder label: () -> Label) {
        self.destination = destination
        self.label = label()
    }
    var body: some View {
        NavigationLink {
            CustomNavBarContainerView {
                destination
                    .navigationBarHidden(true)
            }
        } label: {
            label
        }
    }
}


extension UINavigationController {
    open override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = nil
    }
}
