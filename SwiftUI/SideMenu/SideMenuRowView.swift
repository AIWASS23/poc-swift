import SwiftUI

// This struct defines a row view for an item in the side menu
struct SideMenuRowView: View {
    let option: SideMenuOptionModel // The menu option for this row
    @Binding var slectModel: SideMenuOptionModel? // Binding to the selected menu option

    // Computed property to determine if this row is selected
    private var slected: Bool {
        return slectModel == option
    }

    var body: some View {
        HStack {
            // Displaying an icon for the menu option
            Image(systemName: option.imageName)
                .imageScale(.small) // Setting the image scale to small

            // Displaying the title for the menu option
            Text(option.title)
                .font(.subheadline) // Applying the subheadline font style

            Spacer()
        }
        .padding(.leading) // Adding padding to the left
        .foregroundStyle(slected ? .blue : .primary) // Changing the foreground color based on selection
        .frame(height: 44) // Setting the frame height
        .background(slected ? .blue.opacity(0.15) : .clear) // Changing the background based on selection
        .clipShape(RoundedRectangle(cornerRadius: 10)) // Clipping the view with rounded corners
    }
}

#Preview {
    SideMenuRowView(option: .dashbord, slectModel: .constant(.dashbord))
}
