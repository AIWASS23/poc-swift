
import SwiftUI

struct CustomDialogContentView: View {
	@State private var isActive: Bool = false
	
	var body: some View {
		ZStack {
			VStack {
				Button {
					isActive = true
				} label: {
					Text("Show Popup")
						.fontWeight(.medium)
				}
				.foregroundStyle(.blue)
			}
			.padding()
			
			if isActive {
				CustomDialog(
					isActive: $isActive,
					title: "Access photos?",
					message: "This lets you choose which photos you want to add to this project.",
					buttonTitle: "Give Access",
					action: {
						
					}
				)
			}
		}
	}
}

#Preview {
	CustomDialogContentView()
}
