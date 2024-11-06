
import SwiftUI

struct FBGradientMaskContentView: View {
	var body: some View {
		NavigationStack {
			FBGradientMaskHomeView()
				.navigationTitle("Messages")
		}
	}
}

#Preview {
	FBGradientMaskContentView()
}
