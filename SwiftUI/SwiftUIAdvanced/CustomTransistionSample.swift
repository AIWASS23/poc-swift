import SwiftUI

struct CustomTransistionSample: View {

    @State private var transitionType: Int = 0
    @State private var showRectangle: Bool = false

    var body: some View {
        VStack {
            HStack(spacing: 10) {
                Button {
                    transitionType = 0
                } label: {
                    Text("Transition 1")
                        .font(.headline)
                        .withDefaultButtonFormmating(.orange)
                }
                .withPressableButtonStyle()
                
                Button {
                    transitionType = 1
                } label: {
                    Text("Transition 2")
                        .font(.headline)
                        .withDefaultButtonFormmating(.indigo)
                }
                .withPressableButtonStyle()
            }
            .padding(.horizontal,30)
            
            if showRectangle{
                RoundedRectangle(cornerRadius: 25)
                    .fill(LinearGradient(colors: [Color.blue,Color.blue.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 250,height: 350)
                    .frame(maxWidth: .infinity,maxHeight: .infinity)
                    .transition(transitionType == 0 ? .rotating(rotationAngle: 1080) : .rotationOn)
            }
            
            Spacer()
            
            Text("Click Me!")
                .withDefaultButtonFormmating()
                .padding(.horizontal,40)
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        showRectangle.toggle()
                    }
                }
        }
    }
}

struct CustomTransistionSample_Previews: PreviewProvider {
    static var previews: some View {
        CustomTransistionSample()
    }
}
