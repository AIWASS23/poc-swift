import SwiftUI

struct ReposView: View {
    @StateObject var viewModel = ReposViewModel()
    var body: some View {
        List(viewModel.repos){ repo in
            Label {
                Text(repo.name)
            } icon: {
                avatar(repo: repo)
            }
        }
    }
    
    func avatar(repo:Item) -> some View{
        AsyncImage(url: URL(string: repo.owner.avatarURL),transaction: .init(animation: .default)) { result in
            switch result{
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
            default:
                ProgressView()
            }
        }
    }
}

struct ReposView_Previews: PreviewProvider {
    static var previews: some View {
        ReposView()
    }
}
