import SwiftUI

// This struct defines the header view for the side menu in the SwiftUI application
struct SideMenuHeaderView: View {
    var body: some View {
        HStack {
            // Displaying an image with a circular icon
            Image(systemName: "person.crop.circle.fill")
                .imageScale(.large) // Increasing the size of the image
                .foregroundStyle(.white) // Setting the foreground color to white
                .frame(width: 48, height: 48) // Setting the frame for the image
                .background(.blue) // Applying a blue background
                .clipShape(RoundedRectangle(cornerRadius: 10)) // Clipping the image with rounded corners
                .padding(.vertical) // Adding vertical padding

            VStack(alignment: .leading, spacing: 3) {
                // User's name
                Text("Marcelo De Araújo")
                    .font(.subheadline) // Applying subheadline font style
                // User's email
                Text("marcelol@gmail.com")
                    .tint(.gray) // Applying gray tint
            }
        }
    }
}

#Preview {
    SideMenuHeaderView()
}
