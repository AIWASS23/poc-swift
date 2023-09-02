import SwiftUI

struct ContentView: View {
    var body: some View {
        WaterShape()
            .fill(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)),Color(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .ignoresSafeArea()
//            .frame(width: 200,height: 200)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct shapeWithArc: Shape {
    func path(in rect: CGRect) -> Path {
        Path{ path in
            path.move(to: CGPoint(x: rect.minX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
            path.addArc(center: CGPoint(x: rect.midX, y: rect.minY), radius: rect.height / 2, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 180), clockwise: false)
            path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        }
    }
}

struct QuadShape: Shape {
    func path(in rect: CGRect) -> Path {
        Path{ path in
            path.move(to: .zero)
            path.addQuadCurve(to: CGPoint(x: rect.midX, y: rect.midY), control: CGPoint(x: rect.maxX - 50, y: rect.midY - 100))
        }
    }
}


struct WaterShape: Shape {
    func path(in rect: CGRect) -> Path {
        Path{path in
            path.move(to: CGPoint(x: rect.minX, y: rect.midY))
            path.addQuadCurve(to: CGPoint(x: rect.midX, y: rect.midY), control: CGPoint(x: rect.width * 0.25, y: rect.height * 0.40))
            path.addQuadCurve(to: CGPoint(x: rect.maxY, y: rect.midY), control: CGPoint(x: rect.width * 0.75, y: rect.height * 0.60))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        }
    }
}
