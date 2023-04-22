import SwiftUI

struct MovieList: View {

    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(

        entity: Movie.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Movie.title, ascending: true)
        ]
        //,predicate: NSPredicate(format: "genre contains 'Action'")
    ) var movies: FetchedResults<Movie>

    /*
        Esta é uma propriedade @FetchRequest em MovieList que é usada para buscar dados de filmes do 
        CoreData. A propriedade movies é uma coleção FetchedResults<Movie> que contém todos os objetos 
        Movie armazenados no CoreData e que correspondem aos critérios de busca especificados no 
        FetchRequest. O FetchRequest busca todos os objetos Movie e os ordena por título em ordem 
        crescente. A busca é executada automaticamente pelo CoreData e a propriedade movies é atualizada 
        automaticamente sempre que há uma mudança nos dados do CoreData que corresponda aos critérios de 
        busca. Essa propriedade @FetchRequest é uma maneira simples e eficiente de buscar dados do 
        CoreData em um objeto gerenciado do SwiftUI. O SwiftUI gerencia automaticamente as atualizações 
        da interface do usuário com base nas alterações nos dados do CoreData, o que torna o 
        desenvolvimento de aplicativos que usam o CoreData mais fácil e menos suscetível a erros.

        entity: é o argumento obrigatório e especifica a entidade do Core Data que você deseja buscar. 
        Deve ser uma subclasse de NSManagedObject. Por exemplo, se você tiver uma entidade chamada Movie 
        em seu modelo de dados, você pode especificá-la usando Movie.entity().

        sortDescriptors: é um argumento opcional que especifica uma ou mais descrições de ordenação para 
        os resultados da busca. Uma descrição de ordenação é criada com a classe NSSortDescriptor e 
        especifica a propriedade pela qual os resultados devem ser ordenados e a direção da ordenação 
        (ascendente ou descendente). Por exemplo, para ordenar os resultados pelo título em ordem 
        crescente, você pode usar NSSortDescriptor(keyPath: \Movie.title, ascending: true). Você pode 
        passar várias descrições de ordenação para ordenar os resultados por várias propriedades.

        predicate: é um argumento opcional que especifica uma expressão que define os critérios de 
        filtragem dos objetos que devem ser buscados. A expressão é criada com a classe NSPredicate e 
        pode ser usada para filtrar objetos com base em valores de propriedade específicos. Por exemplo, 
        se você quiser buscar apenas os filmes do gênero "Ação", você pode usar NSPredicate
        (format: "genre == %@", "Ação").

        animation: é um argumento opcional que especifica o tipo de animação que deve ser usada para 
        atualizar a exibição quando os resultados da busca mudam. O valor padrão é .default.

        id: é um argumento opcional que especifica uma chave de identificação única para os objetos na 
        coleção de resultados. Por padrão, o @FetchRequest usa a propriedade objectID dos objetos 
        gerenciados como chave de identificação, mas você pode especificar uma chave de identificação 
        personalizada, como o valor da propriedade title de um objeto Movie, por exemplo.

        sectionNameKeyPath: é um argumento opcional que especifica o caminho para a propriedade que deve 
        ser usada para agrupar os resultados da busca em seções. Por exemplo, se você quiser agrupar os 
        filmes por gênero, pode usar sectionNameKeyPath: "genre".

        limit: é um argumento opcional que especifica o número máximo de resultados que a busca deve 
        retornar. O valor padrão é nil, o que significa que não há limite.

        offset: é um argumento opcional que especifica o número de resultados a serem ignorados no 
        início da busca. O valor padrão é 0.

        propertiesToFetch: é um argumento opcional que especifica uma lista de propriedades que devem 
        ser recuperadas da loja persistente para cada objeto gerenciado buscado. O valor padrão é nil, 
        o que significa que todas as propriedades serão buscadas. Isso pode ser útil quando você tem uma 
        entidade com muitas propriedades e quer melhorar o desempenho da busca especificando apenas as 
        propriedades necessárias.
    */
  
    @State var isPresented = false
  
    var body: some View {
        NavigationView {
            List {
                ForEach(movies, id: \.title) { MovieRow(movie: $0)}
                    .onDelete(perform: deleteMovie)
            }
            .sheet(isPresented: $isPresented) {
                AddMovie { title, genre, release in
                    self.addMovie(title: title, genre: genre, releaseDate: release)
                    self.isPresented = false
                }
            }
            .navigationBarTitle(Text("Marcelo"))
            .navigationBarItems(
                trailing: Button(
                    action: { 
                        self.isPresented.toggle() 
                    }
                ) {
                    Image(systemName: "plus")
                }
            )
        }
    }
    
    func deleteMovie(at offsets: IndexSet) {
        offsets.forEach { index in 
            let movie = self.movies[index]
            self.managedObjectContext.delete(movie)
        }
        saveContext()
    }
    
    
    func addMovie(title: String, genre: String, releaseDate: Date) {
        let newMovie = Movie(context: managedObjectContext)
    
        newMovie.title = title
        newMovie.genre = genre
        newMovie.releaseDate = releaseDate
        
        saveContext()
    }
    
    
    func saveContext() {
        do {
            try managedObjectContext.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
}

/*
    O MovieList implementa uma tela de lista de filmes que usa o CoreData para armazenar e recuperar 
    dados de filmes. A estrutura MovieList possui um FetchRequest que busca todos os filmes armazenados 
    no CoreData e os exibe em uma lista usando um componente List do SwiftUI.

    A tela de lista de filmes possui um botão "Adicionar" na barra de navegação que, quando pressionado, 
    apresenta uma tela modal de adição de filmes (AddMovie) usando o método sheet. A tela modal é 
    apresentada quando a variável isPresented é definida como true.

    O usuário pode excluir um filme da lista deslizando o dedo para a esquerda no filme e tocando no 
    botão "Excluir". O método onDelete é chamado em resposta a essa ação e remove o filme selecionado do 
    CoreData.

    A função addMovie é chamada pela tela de adição de filmes (AddMovie) quando o usuário insere o 
    título, o gênero e a data de lançamento de um novo filme e clica no botão "Adicionar". A função cria 
    uma nova instância da entidade Movie no CoreData e preenche seus atributos com os valores fornecidos 
    pelo usuário.

    A função saveContext é responsável por salvar as alterações no contexto gerenciado do CoreData.
*/