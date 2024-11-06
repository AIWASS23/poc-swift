import SwiftUI

struct GridAnimationContentView: View {
	var body: some View {
		NavigationStack {
			GridAnimationHomeView()
				.toolbar(.hidden, for: .navigationBar)
		}
	}
}

#Preview {
	GridAnimationContentView()
}
