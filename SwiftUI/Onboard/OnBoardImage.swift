import SwiftUI

struct OnboardingIcon: View {

    let image: String
    let title: String
    let text: String
    
    var body: some View {
        HStack {
            Image(image)
                .frame(width: 75)
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                Text(text)
            }
            Spacer()
        }
    }
}