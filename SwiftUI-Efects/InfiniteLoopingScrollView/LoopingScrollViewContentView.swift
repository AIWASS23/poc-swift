
import SwiftUI

struct LoopingScrollViewContentView: View {
	var body: some View {
		NavigationStack {
			LoopingScrollViewHomeView()
				.navigationTitle("Looping ScrollView")
		}
	}
}

#Preview {
	LoopingScrollViewContentView()
}
