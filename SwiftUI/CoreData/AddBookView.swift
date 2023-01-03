import SwiftUI

/*
    O AddBookView possui várias propriedades e métodos:

    moc é um gerenciador de objetos gerenciado que é usado para 
    gerenciar a mudança de estado de objetos gerenciados (como objetos Core Data).

    dismiss é uma função de cancelamento que é usada para fechar a AddBookView.

    title, author, rating, genre, e review são estados privados que armazenam os 
    valores dos campos de formulário da AddBookView.

    genres é uma matriz de gêneros literários que são exibidos em um componente de 
    seleção na interface do usuário.

    body é a parte principal da interface do usuário que é exibida pelo AddBookView. 
    A interface do usuário consiste em um formulário com campos 
    para o título, o autor, o gênero, a classificação e a revisão de um livro. 
    Há também um botão "Salvar" na parte inferior do formulário que, quando pressionado, 
    cria um novo objeto Book com os valores dos campos do formulário e o 
    adiciona ao gerenciador de objetos gerenciado. 
    Em seguida, a função de cancelamento é chamada para fechar a AddBookView.
*/

struct AddBookView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss

    @State private var title = ""
    @State private var author = ""
    @State private var rating = 3
    @State private var genre = ""
    @State private var review = ""

    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name of book", text: $title)
                    TextField("Author's name", text: $author)

                    Picker("Genre", selection: $genre) {
                        ForEach(genres, id: \.self) {
                            Text($0)
                        }
                    }
                }

                Section {
                    TextEditor(text: $review)
                    RatingView(rating: $rating)
                } header: {
                    Text("Write a review")
                }

                Section {
                    Button("Save") {

                        /*
                            Para usar o Core Data no SwiftUI, você deve seguir os seguintes passos:

                            Adicione o framework Core Data ao seu projeto. Isso pode ser feito no Xcode 
                            selecionando o alvo do seu aplicativo e, em seguida, clicando em 
                            "Editor de configurações do alvo" e selecionando o framework Core Data 
                            na guia "Geral".

                            Crie um modelo de dados. O modelo de dados é um arquivo que define a 
                            estrutura dos objetos de dados que serão armazenados pelo Core Data. 
                            Você pode criar um modelo de dados no Xcode clicando em "Arquivo" 
                            e selecionando "Novo" e "Modelo de dados".

                            Crie um gerenciador de objetos gerenciado. O gerenciador de objetos gerenciado 
                            é responsável por criar, recuperar, atualizar e excluir objetos de dados. 

                            Para usar o Core Data com o SwiftUI, você precisará criar um gerenciador 
                            de contexto de persistência (NSManagedObjectContext). 
                            Este gerenciador é responsável por salvar e carregar os seus 
                            objetos gerenciados (NSManagedObject). Em seguida, você pode usar este 
                            gerenciador de contexto para criar, atualizar, ler e excluir objetos gerenciados 
                            em sua base de dados.
                        */
                        let newBook = Book(context: moc)
                        newBook.id = UUID()
                        newBook.title = title
                        newBook.author = author
                        newBook.rating = Int16(rating)
                        newBook.review = review
                        newBook.genre = genre

                        try? moc.save()
                        dismiss()
                    }
                }
            }
            .navigationTitle("Add Book")
        }
    }
}