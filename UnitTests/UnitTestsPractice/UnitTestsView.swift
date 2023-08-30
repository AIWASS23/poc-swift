import SwiftUI

struct UnitTestsView: View {
    
    @StateObject private var viewModel: UnitTestsViewModel
    
    init(isPremium:Bool) {
        self._viewModel = StateObject(wrappedValue: UnitTestsViewModel(isPremium: isPremium))
    }
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct UnitTestsView_Previews: PreviewProvider {
    static var previews: some View {
        UnitTestsView(isPremium: true)
    }
}
