import SwiftUI

// This struct defines the SideMenuView in the SwiftUI application
struct SideMenuView: View {
    @Binding var isShowMenue: Bool // Binding to control the visibility of the menu
    @State var slectModel: SideMenuOptionModel? // State for selected menu option
    @Binding var slectTab: Int // Binding to keep track of the selected tab
    @State private var dragOffset = CGSize.zero // State for managing drag gesture offset
    @Environment(\.colorScheme) var colorScheme // Environment property to detect color scheme

    // Computed property to determine the background color based on the color scheme
    var backgroundForColorScheme: Color {
        return colorScheme == .dark ? Color.black : Color.white
    }

    var body: some View {
        ZStack {
            // Overlay rectangle that appears when the menu is shown
            if isShowMenue {
                Rectangle()
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isShowMenue.toggle()
                    }

                HStack {
                    // Menu content
                    VStack(alignment: .leading, spacing: 32) {
                        SideMenuHeaderView() // Header view for the side menu

                        VStack {
                            // Looping through menu options
                            ForEach(SideMenuOptionModel.allCases) { option in
                                Button {
                                    slectModel = option
                                    slectTab = option.rawValue
                                    isShowMenue.toggle()
                                } label: {
                                    SideMenuRowView(option: option, slectModel: $slectModel)
                                }
                            }
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                    .frame(width: 250, alignment: .leading)
                    .background(backgroundForColorScheme.opacity(0.8)) // Applying background color
                    Spacer()
                }
                .offset(x: dragOffset.width, y: 0)
                // Drag gesture to allow swiping the menu away
                .gesture(
                    DragGesture()
                        .onChanged({ gesture in
                            if gesture.translation.width < 0 {
                                self.dragOffset = gesture.translation
                            }
                        })
                        .onEnded({ _ in
                            if self.dragOffset.width < -100 {
                                withAnimation {
                                    self.isShowMenue = false
                                }
                            }
                            self.dragOffset = .zero
                        })
                )
            }
        }
        .transition(.move(edge: .leading)) // Animation for the menu appearance
        .animation(.easeInOut(duration: 0.2), value: isShowMenue)
    }
}

#Preview {
    SideMenuView(isShowMenue: .constant(true), slectTab: .constant(0))
}
