import SwiftUI

struct AddMovie: View {
  static let DefaultMovieTitle = "An untitled masterpiece"
  static let DefaultMovieGenre = "Genre-buster"

  @State var title = ""
  @State var genre = ""
  @State var releaseDate = Date()
  let onComplete: (String, String, Date) -> Void

  var body: some View {
    NavigationView {
      Form {
        Section(header: Text("Title")) {
          TextField("Title", text: $title)
        }
        Section(header: Text("Genre")) {
          TextField("Genre", text: $genre)
        }
        Section {
          DatePicker(
            selection: $releaseDate,
            displayedComponents: .date) {
              Text("Release Date").foregroundColor(Color(.gray))
            }
        }
        Section {
          Button(action: addMoveAction) {
            Text("Add Movie")
          }
        }
      }
      .navigationBarTitle(Text("Add Movie"), displayMode: .inline)
    }
  }

  private func addMoveAction() {
    onComplete(
      title.isEmpty ? AddMovie.DefaultMovieTitle : title,
      genre.isEmpty ? AddMovie.DefaultMovieGenre : genre,
      releaseDate)
  }
}
/*
    AddMovie contém três propriedades com estado (@State): title, genre e releaseDate. Essas 
    propriedades são inicializadas com valores vazios para permitir que o usuário insira os detalhes do 
    filme. Ela possui uma propriedade onComplete, que é uma função de retorno de chamada que é invocada 
    quando o usuário clica no botão "Add Movie". A função addMoveAction é chamada nesse botão, que 
    recupera os valores inseridos pelo usuário para título, gênero e data de lançamento e, em seguida, 
    chama a função onComplete com esses valores.

    A interface do usuário é construída usando o formulário Form do SwiftUI e é dividida em quatro seções:
    "Title", "Genre", "Release Date" e um botão "Add Movie". Cada seção é definida usando a estrutura 
    Section e contém um componente de interface do usuário relevante. Por exemplo, a seção "Title" 
    contém um campo de texto TextField que permite ao usuário inserir o título do filme. A seção "Release
    Date" contém um seletor de data DatePicker que permite ao usuário selecionar a data de lançamento do 
    filme.
*/