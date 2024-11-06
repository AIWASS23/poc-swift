
import SwiftUI

struct ControlCenterContentView: View {
	var body: some View {
		GeometryReader {
			let size = $0.size
			let safeArea  = $0.safeAreaInsets
			
			ControlCenterHomeView(size: size, safeArea: safeArea)
				.ignoresSafeArea(.container, edges: .all)
		}
	}
}

#Preview {
	ControlCenterContentView()
}
