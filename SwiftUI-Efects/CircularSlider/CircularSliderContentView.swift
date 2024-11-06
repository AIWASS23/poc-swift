import SwiftUI

struct CircularSliderContentView: View {
	var body: some View {
		NavigationStack {
			CircularSliderHomeView()
				.navigationTitle("Trip Planner")
		}
	}
}

#Preview {
	CircularSliderContentView()
}
