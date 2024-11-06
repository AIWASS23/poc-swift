import SwiftUI

struct AutoScrollingTabContentView: View {
	var body: some View {
		AutoScrollingHomeView()
			.preferredColorScheme(.dark)
	}
}

#Preview {
	AutoScrollingTabContentView()
}
