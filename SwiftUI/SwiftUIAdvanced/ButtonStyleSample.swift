import SwiftUI

// PressableButtonStyle
struct PressableButtonStyle: ButtonStyle {
    let scaleEffect:CGFloat
    
    init(scaleEffect: CGFloat = 0.9) {
        self.scaleEffect = scaleEffect
    }
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scaleEffect : 1.0)
            //.brightness(configuration.isPressed ? 0.1 : 0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
    }
}

// ButtonStyleSample
struct ButtonStyleSample: View {
    var body: some View {
        VStack(spacing: 10){
            Button {
                
            } label: {
                Text("CLICK ME!!!")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .shadow(color: Color.blue.opacity(0.3), radius: 10, x: 0.0, y: 10)
            }
            .buttonStyle(PressableButtonStyle())
            
            Button {
                
            } label: {
                Text("CLICK ME!!!")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .shadow(color: Color.blue.opacity(0.3), radius: 10,x: 0.0,y: 10)
            }
            .buttonStyle(PressableButtonStyle(scaleEffect: 0.7))
            
            Button {
                
            } label: {
                Text("CLICK ME!!!")
                    .withDefaultButtonFormmating(.red)
            }
            .withPressableButtonStyle()

        }
        .padding(40)
    }
}

struct ButtonStyleSample_Previews: PreviewProvider {
    static var previews: some View {
        ButtonStyleSample()
    }
}
