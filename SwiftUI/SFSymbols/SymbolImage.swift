import SwiftUI

struct SymbolIcon: View {
    
    let icon: String
    @Binding var selection: String
    
    var body: some View {
        Image(systemName: icon)
            .font(.system(size: 25))
            .animation(.linear)
            .foregroundColor(
                self.selection == icon ? Color.accentColor : Color.primary
            )
            .onTapGesture {
                withAnimation {
                    self.selection = icon
                }
            }
    }
}

#Preview {
    SymbolIcon(icon: "beats.powerbeatspro", selection: .constant("star.bubble"))
}
