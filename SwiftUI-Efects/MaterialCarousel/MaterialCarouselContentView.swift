import SwiftUI

struct MaterialCarouselContentView: View {
	var body: some View {
		NavigationStack {
			MaterialCarouselHomeView()
				.navigationTitle("Carousel")
		}
	}
}

#Preview {
	MaterialCarouselContentView()
}
