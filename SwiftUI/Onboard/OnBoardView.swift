import SwiftUI

struct OnboardingView: View {

    @Environment(\.dismiss) var dismiss

    
    var body: some View {

        VStack{
            ScrollView {
                VStack {
                    VStack {
                        Text("Bem vindo ao Turtle")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.vertical, 20)
                        Text("Controle seu consumo de água e mantenha-se hidratado enquanto salva um ecossistema da seca")
                            .padding(.horizontal, 10)
                    }
                    .padding(.vertical, 50)


                    OnboardingIcon(image: "image1", title: "Integrado com o health", text: "Tenha controle do seu consumo diário de água")

                    OnboardingIcon(image: "image2", title: "Cenários em 3D", text: "App com cenário 3D onde você acompanha seu progresso de forma interativa")

                    OnboardingIcon(image: "image3", title: "Widgets", text: "Visualize seu progresso rapidamente através dos widgets")

                    OnboardingIcon(image: "image4", title: "Notificações", text: "Receba lembretes para beber água durante seu dia ")
                }
                .padding()
                .padding()
            }
            Button {

                dismiss()
                UserDefaults.standard.set(true, forKey:"showOnboarding" )

            } label: {
                Text("Continue")
                    .frame(maxWidth: 320 )
                    .frame(height: 45)

            }
            .buttonStyle(.borderedProminent)
            .padding()
            Spacer()
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
