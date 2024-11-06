import SwiftUI

struct HorizontalWheelPickerContentView: View {
	@State private var config = WheelPicker.Config(count: 30, steps: 5, spacing: 15, multiplier: 10)
	@State private var value: CGFloat = 10
	
	var body: some View {
		NavigationStack {
			VStack {
				HStack(alignment: .lastTextBaseline, spacing: 5, content: {
					Text(verbatim: "\(value)")
						.font(.largeTitle.bold())
						.contentTransition(.numericText(value: value))
						.animation(.snappy, value: value)
					Text("lbs")
						.font(.title2)
						.fontWeight(.semibold)
						.textScale(.secondary)
						.foregroundStyle(.secondary)
					
//					Button("Update") {
//						withAnimation {
//							value = 125
//						}
//					}
				})
				.padding(.bottom, 30)
				
				WheelPicker(config: config, value: $value)
					.frame(height: 60)
			}
			.navigationTitle("Wheel Picker")
		}
	}
}

#Preview {
	HorizontalWheelPickerContentView()
}
