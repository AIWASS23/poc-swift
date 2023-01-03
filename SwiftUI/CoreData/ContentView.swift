import SwiftUI

/*
    O ContentView possui várias propriedades e métodos:

    moc é um gerenciador de objetos gerenciado que é usado para gerenciar 
    a mudança de estado de objetos gerenciados (como objetos Core Data).

    books é um conjunto de resultados obtidos que é preenchido com objetos do tipo Book. 
    Os resultados são classificados por título e, em seguida, por autor.

    showingAddScreen é um estado privado que indica se a tela de adição de livros 
    está sendo exibida ou não.

    body é a parte principal da interface do usuário que é exibida pelo ContentView. 
    A interface do usuário consiste em uma lista de livros com um botão "Editar" 
    na barra de ferramentas e um botão "Adicionar livro" na barra de navegação. 
    Se o botão "Adicionar livro" for pressionado, a tela de adição de livros será exibida. 
    Se um livro na lista for pressionado, a tela de detalhes do livro será exibida.

    deleteBooks é um método que é chamado quando um ou mais livros são excluídos da lista. 
    O método exclui os livros do gerenciador de objetos gerenciado e, 
    em seguida, salva as alterações .
*/

struct ContentView: View {

    /*
        No SwiftUI, a propriedade @Environment é usada para acessar valores do ambiente de uma view. 
        O ambiente é um conjunto de valores que são compartilhados por todas as views 
        e na hierarquia de exibição de uma aplicação.

        Por exemplo, você pode usar a propriedade @Environment para acessar o gerenciador 
        de objetos gerenciado de uma aplicação Core Data em todas as views de uma aplicação, como este:

        @Environment(\.managedObjectContext) var moc

        Podemos criar seu próprio ambiente personalizado e acessá-lo usando a 
        propriedade @Environment. Por exemplo:

        struct MyEnvironmentKey: EnvironmentKey {
            static let defaultValue: Int = 0
        }

        extension EnvironmentValues {
            var myValue: Int {
                get { self[MyEnvironmentKey.self] }
                set { self[MyEnvironmentKey.self] = newValue }
            }
        }

        // Use o @Environment em uma view

        struct MyView: View {
            @Environment(\.myValue) var myValue: Int

            var body: some View {
                // Use myValue aqui
            }
        }

        // Defina o @Environment em uma parent view
        struct ParentView: View {
            var body: some View {
                MyView()
                    .environment(\.myValue, 42)
            }
        }
    */
    @Environment(\.managedObjectContext) var moc

    /*
        No SwiftUI, a propriedade @FetchRequest é usada para preencher um conjunto de 
        resultados obtidos com objetos de um gerenciador de objetos gerenciado 
        (como um gerenciador de objetos gerenciado Core Data).

        A propriedade @FetchRequest é usada da seguinte maneira:


        @FetchRequest(sortDescriptors: [
            SortDescriptor(\.title),
            SortDescriptor(\.author)
        ]) var books: FetchedResults<Book>

        Neste exemplo, a propriedade books é preenchida com objetos do tipo 
        Book que são obtidos do gerenciador de objetos gerenciado. 
        Os resultados são classificados primeiro pelo título e, em seguida, pelo autor.

        Você pode usar a propriedade @FetchRequest para exibir os resultados em uma lista, como este:

        List {
            ForEach(books) { book in
                Text(book.title)
            }
        }

        A propriedade @FetchRequest é atualizada automaticamente quando o 
        gerenciador de objetos gerenciado é alterado, o que significa que a 
        lista de livros será atualizada automaticamente se um novo livro 
        for adicionado ou um livro existente for excluído.
    */

    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.title),
        SortDescriptor(\.author)
    ]) var books: FetchedResults<Book>

    @State private var showingAddScreen = false

    var body: some View {
        NavigationView {
            List {
                ForEach(books) { book in
                    NavigationLink {
                        DetailView(book: book)
                    } label: {
                        HStack {
                            EmojiRatingView(rating: book.rating)
                                .font(.largeTitle)

                            VStack(alignment: .leading) {
                                Text(book.title ?? "Unknown Title")
                                    .font(.headline)

                                Text(book.author ?? "Unknown Author")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                .onDelete(perform: deleteBooks)
            }
            .navigationTitle("Bookworm")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddScreen.toggle()
                    } label: {
                        Label("Add Book", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddScreen) {
                AddBookView()
            }
        }
    }

    func deleteBooks(at offsets: IndexSet) {
        for offset in offsets {
            let book = books[offset]
            moc.delete(book)
        }
        try? moc.save()
    }
}
