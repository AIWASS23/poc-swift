import SwiftUI
import RealityKit

extension Entity {
    static func generateYellowSphere(radius: Float) -> Entity {
        let sphereMesh = MeshResource.generateSphere(radius: radius)
        let yellowMaterial = SimpleMaterial(color: .yellow, isMetallic: false)
        let modelEntity = ModelEntity(mesh: sphereMesh, materials: [yellowMaterial])
        return modelEntity
    }
}

struct ScaledVolumeContentView: View {
    
    let defaultVolumeSize: Size3D
    
    @State private var scaledContentEntity = Entity()
    
    var body: some View {
        GeometryReader3D { proxy in
            RealityView { content in
                content.add(scaledContentEntity)

                let contentEntity = createVolumeContentEntity(forVolumeSize: defaultVolumeSize)
                scaledContentEntity.addChild(contentEntity)
                
                scaleEntity(scaledContentEntity, with: content, for: proxy, defaultVolumeSize: defaultVolumeSize)
            } update: { content in
                scaleEntity(scaledContentEntity, with: content, for: proxy, defaultVolumeSize: defaultVolumeSize)
            }
        }
    }
    
    func createVolumeContentEntity(forVolumeSize volumeSize: Size3D) -> Entity {
        let sphereRadius = Float(min(volumeSize.width, volumeSize.height, volumeSize.depth)) / 2
        return Entity.generateYellowSphere(radius: sphereRadius)
    }
    
    func scaleEntity(_ entity: Entity, with realityViewContent: RealityViewContent, for geometryProxy3D: GeometryProxy3D, defaultVolumeSize: Size3D) {
        let scaledVolumeContentBoundingBox = realityViewContent.convert(geometryProxy3D.frame(in: .local), from: .local, to: .scene)

        let scale = scaledVolumeContentBoundingBox.extents.x / Float(defaultVolumeSize.width)
        
        entity.scale = [1, 1, 1] * scale
    }
    
}

