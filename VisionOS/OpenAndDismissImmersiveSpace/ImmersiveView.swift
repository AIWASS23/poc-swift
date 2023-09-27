import SwiftUI
import RealityKit

struct ImmersiveView: View {

    @StateObject var model = TextureViewModel()

    private var contentEntity = Entity()
    private var location: CGPoint = .zero
    private var location3D: Point3D = .zero

    var body: some View {
        RealityView { content in
            content.add(model.setupContentEntity())
            model.addCube()
        }
        .gesture(
            SpatialTapGesture()
                .targetedToAnyEntity()
                .onEnded { value in
                    print(value)
                }
        )
    }
}

#Preview {
    ImmersiveView()
        .previewLayout(.sizeThatFits)
}
