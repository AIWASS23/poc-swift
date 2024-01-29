import SwiftUI

struct Wave: View {
    
    init(
        progress: Binding<Float>,
        waveHeight height: CGFloat = 35, 
        wavePhaseDegree: CGFloat = 0.0,
        waveDuration: CGFloat = 3.0,
        waveColor: Color = .gray.opacity(0.5),
        progressAnimation: Animation? = .linear
    ) {
        self.waveHeight = height
        self.phase = wavePhaseDegree.truncatingRemainder(dividingBy: 360.0)
        self.color = waveColor
        self.duration = waveDuration
        self.progressAnimation = progressAnimation
        self._progress = progress
    }
    
    var waveHeight: CGFloat
    var phase: CGFloat
    var duration: CGFloat
    var color: Color
    var progressAnimation: Animation?
    
    
    @Binding var progress: Float
    
    // Using didSet with @State to ensure that it doesn't exceed 1.0 is impossible, so we have to ensure it in the code below.
    // Hint: If you achieve it within an ObservableObject as above, didSet works.
    @State var offset: CGFloat = 0
    
        
    var body: some View {
        GeometryReader { global in
            ZStack(alignment: .bottom) {
                GeometryReader { g in
                    
                    
                    Path { path in
                        let width = global.size.width
                        
                        path.move(to: CGPoint(x: width*2.0, y: (1+cos(phase * .pi / 180)) * waveHeight / 2))
                        path.addLine(to: CGPoint(x:width*2.0,y: global.size.height))
                        path.addLine(to: CGPoint(x:0,y:global.size.height))
                        path.addLine(to: CGPoint(x:0,y: (1+cos(phase * .pi / 180)) * waveHeight / 2))
                        
                        var points = [CGPoint]()
                        for angle in stride(from: phase, through: 180.0*4 + phase, by: 1) {
                            let radian = angle * .pi / 180
                            let cosValue = cos(radian)
                            let x =  CGFloat(angle-phase) * global.size.width / 360
                            let y = (1+cosValue) * waveHeight / 2
                            points.append(CGPoint(x: x, y: y))
                        }
                        
                        path.addLines(points)
                    }
                    .fill(color)
                    
                    .onAppear {
                        if offset >= 1 {
                            offset = 0
                        }
                        offset += 1
                    }
                }
            }
            .frame(width: global.size.width, height: global.size.height)
            .position(x: global.size.width * (0.5-offset),y: global.size.height/2)
            .animation(.linear(duration: duration).repeatForever(autoreverses: false), value: offset)
            .drawingGroup()
            .offset(y:CGFloat(1-progress)*global.size.height)
            .animation(progressAnimation, value: progress)
            
        }
    }
}
