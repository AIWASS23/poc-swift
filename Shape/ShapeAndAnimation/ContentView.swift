import SwiftUI

struct ContentView: View {
    
    @State private var animate:Bool = false
    
    var body: some View {
        VStack{
            RectangleWithAnimation(cornerRadius: animate ? 60 : 0)
                .fill(RadialGradient(colors: [.yellow,.red], center: .bottomTrailing, startRadius: 0, endRadius: 100))
                .frame(width: 250,height: 250)
            Spacer()
            PackMan(offset: animate ? 20 : 0)
                .fill(LinearGradient(colors: [Color.red,Color.mint], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 250,height: 250)
        }
        .onAppear{
            withAnimation(.easeInOut.repeatForever()){
                animate.toggle()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct RectangleWithAnimation: Shape {
    
    var cornerRadius:CGFloat
    
    var animatableData: CGFloat{
        get{cornerRadius}
        set{cornerRadius = newValue}
    }
    
    func path(in rect: CGRect) -> Path {
        Path{ path in
            path.move(to: .zero)
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - cornerRadius))
            path.addArc(center: CGPoint(x: rect.maxX - cornerRadius, y: rect.maxY - cornerRadius),
                        radius: cornerRadius,
                        startAngle: Angle(degrees: 0),
                        endAngle: Angle(degrees: 360),
                        clockwise: false)
            path.addLine(to: CGPoint(x: rect.maxX - cornerRadius, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        }
    }
}


struct PackMan: Shape{
    
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
