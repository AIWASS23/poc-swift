import SwiftUI

struct ViewModifierSample: View {

    var body: some View {
        VStack(spacing: 10) {
            Text("HELLO WORLD - 1")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 55)
                .background(.blue)
                .cornerRadius(10)
                .shadow(radius: 10)
            Text("HELLO WORLD - 2")
                .font(.headline)
                .modifier(DefaultButtonViewModifier(backgroundColor: .blue))
            Text("HELLO WORLD - 3")
                .font(.headline)
                .withDefaultButtonFormmating()
            Text("HELLO WORLD - 4")
                .font(.headline)
                .withDefaultButtonFormmating(.red)
        }
        .padding()
    }
}

struct ViewModifierSample_Previews: PreviewProvider {
    static var previews: some View {
        ViewModifierSample()
    }
}
