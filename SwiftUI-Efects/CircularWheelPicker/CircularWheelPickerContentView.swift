import SwiftUI

struct CircularWheelPickerContentView: View {
	@State private var selection: CGFloat = 0
	
	var body: some View {
		CircularWheelPicker(selection: $selection, from: 0, to: 50, type: .wholeNumbers)
	}
}

#Preview {
	CircularWheelPickerContentView()
}
