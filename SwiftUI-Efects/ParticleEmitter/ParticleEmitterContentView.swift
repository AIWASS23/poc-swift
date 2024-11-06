import SwiftUI

struct ParticleEmitterContentView: View {
	var body: some View {
		NavigationStack {
			ParticleEmitterHomeView()
				.navigationTitle("Particle Effect")
		}
		.preferredColorScheme(.dark)
	}
}

#Preview {
	ParticleEmitterContentView()
}
