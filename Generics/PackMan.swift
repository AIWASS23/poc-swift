import SwiftUI

struct PackMan: View {
    
    @State private var animate:Bool = false
    
    var body: some View {
        VStack{
            PackManCustomShape(offset: animate ? 20 : 0)
                .fill(RadialGradient(colors: [Color.blue,Color.yellow], center: .trailing, startRadius: 0, endRadius: 400))
                .frame(width: 350,height: 350)
        }
        .onAppear {
            withAnimation(.easeInOut.repeatForever()) {
                animate.toggle()
            }
        }
    }
}

struct PackManCustomShape: Shape {
    var offset:Double
    var animatableData: Double{
        get{offset}
        set{offset = newValue}
    }
    
    func path(in rect: CGRect) -> Path {
        Path{ path in
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addArc(center: CGPoint(x: rect.midX, y: rect.minY),
                        radius: rect.height / 2,
                        startAngle: Angle(degrees: offset),
                        endAngle: Angle(degrees: 360 - offset),
                        clockwise: false)
        }
    }

}

struct PackMan_Previews: PreviewProvider {
    static var previews: some View {
        PackMan()
    }
}
