
import SwiftUI

struct CalendarScrollAnimationContentView: View {
	var body: some View {
		GeometryReader {
			let safeArea = $0.safeAreaInsets
			
			CalendarScrollAnimationHomeView(safeArea: safeArea)
				.ignoresSafeArea(.container, edges: .top)
		}
	}
}

#Preview {
	CalendarScrollAnimationContentView()
}
