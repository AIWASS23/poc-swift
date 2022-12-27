import SwiftUI

struct MissionView: View {
    struct CrewMember {
        let role: String
        let astronaut: Astronaut
    }

    let mission: Mission
    let crew: [CrewMember]

    var body: some View {

        /*
            O elemento GeometryReader do SwiftUI é usado para ler as dimensões de um elemento 
            e fornecer essas informações aos elementos filhos. 
            Ele é útil para criar elementos que se adaptam dinamicamente ao 
            tamanho da tela ou de outros elementos, 
            como gráficos ou imagens que se ajustam automaticamente ao tamanho da tela.

            Propriedades:

            size: o tamanho total do elemento GeometryReader.

            frame(in:): o retângulo delimitador do elemento GeometryReader 
            em relação a um elemento pai especificado.

            safeAreaInsets: os espaços reservados da área segura do elemento GeometryReader.
        */

        GeometryReader { geometry in
            ScrollView {
                VStack {
                    Image(mission.image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: geometry.size.width * 0.6)
                        .padding(.top)

                    VStack(alignment: .leading) {
                        Rectangle()
                            .frame(height: 2)
                            .foregroundColor(.lightBackground)
                            .padding(.vertical)

                        Text("Mission Highlights")
                            .font(.title.bold())
                            .padding(.bottom, 5)

                        Text(mission.description)

                        Rectangle()
                            .frame(height: 2)
                            .foregroundColor(.lightBackground)
                            .padding(.vertical)

                        Text("Crew")
                            .font(.title.bold())
                            .padding(.bottom, 5)
                    }
                    .padding(.horizontal)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(crew, id: \.role) { crewMember in
                                NavigationLink {
                                    AstronautView(astronaut: crewMember.astronaut)
                                } label: {
                                    HStack {
                                        Image(crewMember.astronaut.id)
                                            .resizable()
                                            .frame(width: 104, height: 72)
                                            .clipShape(Capsule())
                                            .overlay(
                                                Capsule()
                                                    .strokeBorder(.white, lineWidth: 1)
                                            )

                                        VStack(alignment: .leading) {
                                            Text(crewMember.astronaut.name)
                                                .foregroundColor(.white)
                                                .font(.headline)

                                            Text(crewMember.role)
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                    }
                }
                .padding(.bottom)
            }
        }
        .navigationTitle(mission.displayName)
        .navigationBarTitleDisplayMode(.inline)
        .background(.darkBackground)
    }

    init(mission: Mission, astronauts: [String: Astronaut]) {
        self.mission = mission

        self.crew = mission.crew.map { member in
            if let astronaut = astronauts[member.name] {
                return CrewMember(role: member.role, astronaut: astronaut)
            } else {
                fatalError("Missing \(member.name)")
            }
        }
    }
}
/*
    O protocolo PreviewProvider do SwiftUI é usado para criar pré-visualizações para suas telas no Xcode. 
    Ele é usado principalmente para testar a aparência e o comportamento de suas telas em 
    diferentes tamanhos de tela, dispositivos e configurações de idioma.

    A propriedade previews é um closure que retorna uma visualização para exibir na pré-visualização.

    O protocolo PreviewProvider também possui várias propriedades e métodos 
    que permitem controlar o tamanho, o dispositivo e outras configurações da pré-visualização. 
    

    previewDevice(_:): permite especificar o dispositivo a ser usado na pré-visualização.
    previewLayout(_:): permite especificar o layout a ser usado na pré-visualização, como .fixed ou .sizeThatFits.
    previewDisplayName(_:): permite especificar um nome a ser exibido na pré-visualização.
*/
struct MissionView_Previews: PreviewProvider {
    static let missions: [Mission] = Bundle.main.decode("missions.json")
    static let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")

    static var previews: some View {
        MissionView(mission: missions[0], astronauts: astronauts)
            .preferredColorScheme(.dark)
    }
}

/*
    A propriedade preferredColorScheme do SwiftUI é usada para obter o 
    esquema de cores atualmente preferido pelo usuário em seu dispositivo. 
    Ela pode ser usada para alterar a aparência de sua aplicação de acordo com o 
    esquema de cores selecionado pelo usuário.

    A propriedade preferredColorScheme é do tipo ColorScheme e pode assumir os seguintes valores:

    .light: o esquema de cores claro é selecionado pelo usuário.
    .dark: o esquema de cores escuro é selecionado pelo usuário.
    .unspecified: o esquema de cores não foi especificado pelo usuário ou 
    o sistema operacional não fornece suporte para esquemas de cores.
*/
