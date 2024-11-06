
import SwiftUI

struct AnimatedTabContentView: View {
	@State private var tabSelection: Int = 0
	
	var body: some View {
		NavigationStack {
			VStack {
				BookInfoView()
				TabSelectionView(tabSelection: $tabSelection)
				
				TabView(selection: $tabSelection) {
					DiscussionListView()
						.tag(0)
					
					Text("Tab 2")
						.font(.largeTitle)
						.fontWeight(.bold)
						.tag(1)
					
					Text("Tab 3")
						.font(.largeTitle)
						.fontWeight(.bold)
						.tag(2)
				}
				.tabViewStyle(.page(indexDisplayMode: .never))
			}
		}
	}
}

#Preview {
	AnimatedTabContentView()
}
