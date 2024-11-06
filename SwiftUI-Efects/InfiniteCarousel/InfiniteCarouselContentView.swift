import SwiftUI

struct InfiniteCarouselContentView: View {
	var body: some View {
		NavigationStack {
			CarouselHomeView()
				.navigationTitle("Infinite Carousel")
		}
	}
}

#Preview {
	InfiniteCarouselContentView()
}
