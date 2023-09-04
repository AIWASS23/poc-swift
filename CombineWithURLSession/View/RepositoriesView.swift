import SwiftUI

struct RepositoriesView: View {
    
    @StateObject var viewModel = RepositoriesViewModel()
    
    var body: some View {
        List(viewModel.respositories){ repo in
            Label {
                Text(repo.name)
            } icon: {
                avatar(repo: repo)
            }
        }
    }
    
    func avatar(repo:Item) -> some View{
        AsyncImage(url: URL(string: repo.owner.avatarURL),transaction: .init(animation: .default)){ result in
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

struct RepositoriesView_Previews: PreviewProvider {
    static var previews: some View {
        RepositoriesView()
    }
}
