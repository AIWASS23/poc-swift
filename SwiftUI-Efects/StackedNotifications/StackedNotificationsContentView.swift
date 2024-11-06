import SwiftUI

struct StackedNotificationsContentView: View {
	var body: some View {
		ZStack {
			GeometryReader { _ in
				Image(.wallpaper)
					.resizable()
					.aspectRatio(contentMode: .fill)
					.ignoresSafeArea()
			}
			StackedNotificationsHomeView()
		}
		.environment(\.colorScheme, .dark)
	}
}

#Preview {
	StackedNotificationsContentView()
}
