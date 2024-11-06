import SwiftUI

struct SwipeableIGLayoutContentView: View {
	var body: some View {
		HomeView()
	}
}

// Global usage values...
var rect = UIScreen.main.bounds
var edges = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.safeAreaInsets
