import SwiftUI

struct FullscreenModalContentView: View {
	@State private var isPresented: BooleanLiteralType = false
	
	var body: some View {
		ZStack {
			NavigationStack {
				VStack {
					Button {
						withAnimation {
							isPresented.toggle()
						}
					}
					label: {
						Text("Show Standard Modal")
					}
				}
				.navigationTitle("Standard")
			}
			
			ZStack {
				Spacer()
				VStack {
					Button {
						withAnimation {
							isPresented.toggle()
						}
					}
					label: {
						Text("Dismiss")
					}
				}
				.frame(maxWidth: .infinity, maxHeight: .infinity)
			}
			.background(.yellow)
			.offset(
				x: 0,
				y: self.isPresented ? 0 : UIApplication.shared.keyWindow?.frame.height ?? 0
			)
			.ignoresSafeArea()
		}
	}
}

#Preview {
	FullscreenModalContentView()
}
