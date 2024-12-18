
import SwiftUI

struct BiometricPINLockContentView: View {
	var body: some View {
		LockView(lockType: .both, lockPin: "0324", isEnabled: true) {
			VStack(spacing: 15) {
				Image(systemName: "globe")
					.imageScale(.large)
				Text("Hello, World!")
			}
		}
	}
}

#Preview {
	BiometricPINLockContentView()
}
