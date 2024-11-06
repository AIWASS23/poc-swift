
import SwiftUI

struct ElasticScrollContentView: View {
	var body: some View {
		NavigationStack {
			ElasticScrollHomeView()
				.navigationTitle("Messages")
		}
	}
}

#Preview {
	ElasticScrollContentView()
}
