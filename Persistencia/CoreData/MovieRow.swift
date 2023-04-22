import SwiftUI

struct MovieRow: View {

    let movie: Movie

    static let releaseFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()

    var body: some View {
        VStack(alignment: .leading) {
            movie.title.map(Text.init)
            .font(.title)
            HStack {
                movie.genre.map(Text.init)
                    .font(.caption)
                Spacer()
                movie.releaseDate.map { Text(Self.releaseFormatter.string(from: $0)) }
                    .font(.caption)
            }
        }
    }
}

/*
    O MovieRow exibe informações sobre um filme. A view recebe um objeto do tipo Movie como parâmetro e 
    exibe o título do filme em uma fonte maior e a data de lançamento e o gênero em uma fonte menor. 
    Ele também define um objeto releaseFormatter, que é uma instância do DateFormatter, usado para 
    formatar a data de lançamento do filme em um formato legível. A formatação é definida no bloco de 
    inicialização do releaseFormatter. A view é composta por um VStack com dois elementos: um Text para o 
    título do filme e um HStack para o gênero e a data de lançamento. O HStack é alinhado à esquerda e 
    consiste em um Text para o gênero, seguido por um Spacer() para empurrar o Text da data de lançamento 
    para a direita e, finalmente, um Text para a data de lançamento, que é formatada usando o 
    releaseFormatter.
*/