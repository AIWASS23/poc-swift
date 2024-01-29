import SwiftUI

// This struct defines the side menu view in the SwiftUI application
struct SideMenu: View {
    @State private var isShowMenue = false  // State to control the visibility of the menu
    @State var slectTab = 0  // State to keep track of the selected tab

    var body: some View {
        NavigationStack {
            ZStack {
                // TabView for switching between different views
                TabView(selection: $slectTab,
                        content: {
                            Text("Dashboard").tag(0)
                            Text("Performance").tag(1)
                            Text("Profile").tag(2)
                            Text("Search").tag(3)
                            Text("Notifications").tag(4)
                        })

                // The custom side menu view
                SideMenuView(isShowMenue: $isShowMenue, slectTab: $slectTab)
            }

            // Hiding the navigation bar if the menu is shown
            .toolbar(isShowMenue ? .hidden : .visible, for: .navigationBar)
            .navigationTitle("Home")  // Setting the navigation title
            .navigationBarTitleDisplayMode(.inline)
            // Toolbar item for toggling the side menu visibility
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        isShowMenue.toggle()
                    } label: {
                        Image(systemName: "line.3.horizontal")  // The menu icon
                    }
                }
            }
        }
    }
}

#Preview {
    SideMenu()
}
