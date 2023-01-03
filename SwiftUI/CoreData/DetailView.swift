import SwiftUI

/*
    O DetailView que exibe detalhes de um livro em uma visualização de rolagem. 
    A visualização exibe a capa do livro, o gênero, o autor, a resenha e a classificação do livro.

    A struct tem um parâmetro book do tipo Book, que é um objeto gerenciado pelo Core Data. 
    Ele também tem duas propriedades de ambiente: moc (gerenciador de contexto de persistência) 
    e dismiss (função para fechar a visualização). Além disso, tem uma propriedade 
    de estado privado chamada showingDeleteAlert, que controla se uma mensagem 
    de alerta de exclusão está sendo exibida ou não.

    A struct também tem um corpo de visualização que exibe os detalhes do livro 
    em uma visualização de rolagem. Ele inclui um botão na barra de ferramentas que, 
    quando pressionado, exibe uma mensagem de alerta perguntando 
    se o usuário deseja excluir o livro. Se o usuário escolher excluir, 
    a função deleteBook() é chamada para excluir o livro da base de dados e fechar a visualização.
*/

struct DetailView: View {
    let book: Book

    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    @State private var showingDeleteAlert = false

    var body: some View {
        ScrollView {
            ZStack(alignment: .bottomTrailing) {
                Image(book.genre ?? "Fantasy")
                    .resizable()
                    .scaledToFit()

                Text(book.genre?.uppercased() ?? "FANTASY")
                    .font(.caption)
                    .fontWeight(.black)
                    .padding(8)
                    .foregroundColor(.white)
                    .background(.black.opacity(0.75))
                    .clipShape(Capsule())
                    .offset(x: -5, y: -5)
            }

            Text(book.author ?? "Unknown Author")
                .font(.title)
                .foregroundColor(.secondary)

            Text(book.review ?? "No review")
                .padding()

            RatingView(rating: .constant(Int(book.rating)))
                .font(.largeTitle)
        }
        .navigationTitle(book.title ?? "Unknown Book")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Delete book?", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive, action: deleteBook)
            /*
                O parâmetro role da função Button é usado para especificar o papel do 
                botão na interface do usuário.

                O parâmetro role é opcional e pode ser usado para fornecer uma pista ao sistema 
                sobre como o botão deve ser tratado. Por exemplo, o sistema pode alterar a 
                aparência do botão ou o comportamento de ação de toque de acordo com o 
                papel especificado. Além de .cancel, outros valores possíveis para o 
                parâmetro role incluem .destructive, .regular e .add.
            */
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure?")
        }
        .toolbar {
            Button {
                showingDeleteAlert = true
            } label: {
                Label("Delete this book", systemImage: "trash")
            }
        }
    }

    func deleteBook() {
        moc.delete(book)

        try? moc.save()
        dismiss()
    }
}

