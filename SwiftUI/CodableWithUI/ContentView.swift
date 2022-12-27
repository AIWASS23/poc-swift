import SwiftUI

struct ContentView: View {

    /*
        O método decode(_:from:) da classe Bundle é usado para decodificar um arquivo de recursos 
        em um determinado pacote de recursos em um objeto do tipo especificado. 
        Ele é geralmente usado para carregar dados estáticos em seu aplicativo, 
        como arquivos JSON ou Property Lists (arquivos .plist).

        A sintaxe para usar o método decode(_:from:) é a seguinte:

        let object: MyType = Bundle.main.decode(MyType.self, from: "fileName.json")

        Onde MyType é o tipo de objeto que você deseja decodificar e fileName.json 
        é o nome do arquivo de recursos que deseja decodificar. 
        O método decode(_:from:) retorna um objeto do tipo especificado (MyType no exemplo acima).

        Para usar o método decode(_:from:), o tipo de objeto que você deseja 
        decodificar deve implementar o protocolo Decodable. 
        Isso permite que o objeto seja decodificado a partir de um arquivo de recursos usando o 
        JSONDecoder ou outro decodificador.
    */

    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")

    let columns = [
        /*
            O elemento GridItem do SwiftUI é usado para especificar o 
            tamanho e o comportamento de cada item em um layout de grade. 
            Ele é usado principalmente em conjunto com o elemento 
            LazyVGrid ou LazyHGrid para criar layouts de grade flexíveis 
            que se ajustam automaticamente ao tamanho da tela do dispositivo.

            O GridItem possui várias propriedades que permitem controlar o 
            tamanho e o comportamento dos itens na grade. 
            Algumas dessas propriedades incluem:

            .fixed(size:length:): especifica um tamanho fixo para o item.

            .flexible(minimum:maximum:): especifica um tamanho flexível para o item, com um tamanho mínimo e máximo.

            .adaptive(minimum:ideal:maximum:): especifica um tamanho adaptável para o item, com tamanhos mínimo, ideal e máximo para diferentes tamanhos de tela.
        */
        GridItem(.adaptive(minimum: 150))
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(missions) { mission in
                        NavigationLink {
                            MissionView(mission: mission, astronauts: astronauts)
                        } label: {
                            VStack {
                                Image(mission.image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .padding()

                                VStack {
                                    Text(mission.displayName)
                                        .font(.headline)
                                        .foregroundColor(.white)

                                    Text(mission.formattedLaunchDate)
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.5))
                                }
                                .padding(.vertical)
                                .frame(maxWidth: .infinity)
                                .background(.lightBackground)
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.lightBackground)
                            )
                        }
                    }
                }
                .padding([.horizontal, .bottom])
            }
            .navigationTitle("Moonshot")
            .background(.darkBackground)
            .preferredColorScheme(.dark)
        }
    }
}
