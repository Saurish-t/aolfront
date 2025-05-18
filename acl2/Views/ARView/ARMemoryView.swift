import SwiftUI
import RealityKit
import ARKit



struct ARMemoryView: UIViewRepresentable {
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal]
        arView.session.run(config)
        
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
        arView.addGestureRecognizer(tapGesture)
        
        context.coordinator.arView = arView
        
        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }

    class Coordinator: NSObject {
        weak var arView: ARView?
        
        @objc func handleTap(_ sender: UITapGestureRecognizer) {
            guard let arView = arView else { return }
            let location = sender.location(in: arView)
            
            guard let result = arView.raycast(from: location, allowing: .estimatedPlane, alignment: .horizontal).first else {
                print("Raycast failed")
                return
            }

            let anchor = AnchorEntity(world: result.worldTransform)
            
            do {
                let model = try ModelEntity.loadModel(named: "boxers.usdz")
                model.generateCollisionShapes(recursive: true)
                anchor.addChild(model)
                arView.scene.anchors.append(anchor)
                print("Placed model in real world")
            } catch {
                print("Failed to load model: \(error)")
            }
        }
    }
}
