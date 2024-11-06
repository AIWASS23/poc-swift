
import SwiftUI

struct CoverFlowContentView: View {
	/// Since our model ID type is UUID
	@State private var activeID: UUID?
	
	var body: some View {
		NavigationStack {
			VStack {
				CustomCarousel(
					config: .init(
						hasOpacity: true,
						hasScale: true,
						cardWidth: 200,
						minimumCardWidth: 30
					),
					selection: $activeID,
					data: images,
					content: {
						item in
						Image(item.image)
							.resizable()
							.aspectRatio(contentMode: .fill)
					}
				)
				.frame(height: 180)
			}
			.navigationTitle("Cover Carousel")
		}
	}
}

#Preview {
	CoverFlowContentView()
}
