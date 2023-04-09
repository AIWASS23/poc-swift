import ActivityKit
import SwiftUI

@available(iOS 16.1, *)

struct ContentView: View {
    @State private var activity: Activity<TimerAttributes>? = nil
    
    var body: some View {
        VStack(spacing: 16) {
            Button("Start Activity") {
                startActivity()
            }
            
            Button("Stop Activity") {
                stopActivity()
            }
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
    }
    
    func startActivity() {
        let attributes = TimerAttributes(timerName: "Dummy Timer")
        let state = TimerAttributes.TimerStatus(endTime: Date().addingTimeInterval(60 * 5))
        
        activity = try? Activity<TimerAttributes>.request(attributes: attributes, contentState: state, pushType: nil)
    }
    
    func stopActivity() {
        let state = TimerAttributes.TimerStatus(endTime: .now)
        
        Task {
            await activity?.end(using: state, dismissalPolicy: .immediate)
        }
    }
    
    func updateActivity() {
        let state = TimerAttributes.TimerStatus(endTime: Date().addingTimeInterval(60 * 10))
        
        Task {
            await activity?.update(using: state)
        }
    }
}

/*
    O ActivityKit cria e gerencia atividades em um aplicativo iOS com SwiftUI. O ActivityKit é um 
    framework disponível na plataforma iOS da Apple que permite a criação e gerenciamento de atividades 
    interativas e baseadas em conteúdo em aplicativos. Ele fornece uma estrutura para criar experiências
    de atividades envolventes, onde os usuários podem interagir com o conteúdo do aplicativo de forma 
    dinâmica, como responder a perguntas, completar tarefas, visualizar informações e assim por diante.

    As atividades criadas com o ActivityKit podem ter diferentes tipos de conteúdo, como texto, imagens,
    vídeos e áudio, e podem ser projetadas para serem executadas em segundo plano ou em primeiro plano,
    dependendo dos requisitos do aplicativo. O framework também oferece suporte para gerenciar o 
    estado das atividades, atualizar o conteúdo e o progresso, e controlar o fluxo de atividades com 
    base nas interações do usuário.

    O ActivityKit é útil em aplicativos que desejam oferecer experiências de atividades interativas, 
    como aplicativos educacionais, aplicativos de treinamento, aplicativos de jogos, aplicativos de 
    criação de conteúdo e outros tipos de aplicativos que envolvem a participação ativa do usuário. 
    Ele permite aos desenvolvedores criar experiências ricas e envolventes para os usuários, 
    proporcionando interações interativas e personalizadas com o conteúdo do aplicativo

    O ContentView contém dois botões: "Start Activity" e "Stop Activity". Quando o botão 
    "Start Activity" é pressionado, o método startActivity() é chamado. Esse método cria uma nova 
    atividade com atributos de timer e estado do timer, utilizando a classe TimerAttributes fornecida 
    pelo framework ActivityKit. O estado do timer é definido para que ele expire em 5 minutos a partir 
    do momento atual. A atividade é armazenada na variável de estado activity para posterior 
    gerenciamento. Quando o botão "Stop Activity" é pressionado, o método stopActivity() é chamado. 
    Esse método atualiza o estado do timer para que ele expire no momento atual, utilizando o 
    método end(using:dismissalPolicy:) da atividade, com uma política de encerramento imediato. 
    Isso efetivamente para a atividade.

    Além disso, há um método updateActivity() que pode ser usado para atualizar a atividade com um novo 
    estado do timer, definido para expirar em 10 minutos a partir do momento atual. 
*/