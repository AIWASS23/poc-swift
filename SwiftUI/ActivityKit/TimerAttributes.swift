import ActivityKit
import SwiftUI

struct TimerAttributes: ActivityAttributes {
    public typealias TimerStatus = ContentState
    
    public struct ContentState: Codable, Hashable {
        var endTime: Date
    }
    
    var timerName: String
}

/*
    A struct representa os atributos de uma atividade de temporizador (TimerAttributes) usando o 
    framework ActivityKit, juntamente com a conformidade aos protocolos ActivityAttributes, Codable e 
    Hashable.

    A estrutura TimerAttributes é definida com as seguintes propriedades e tipos:

    timerName: Uma propriedade de tipo String que representa o nome do temporizador.

    ContentState: Uma estrutura aninhada que representa o estado de conteúdo do temporizador. Essa 
    estrutura é definida como sendo Conforme ao protocolo Codable e Hashable, o que permite a 
    codificação (serialização) e decodificação (desserialização) do estado de conteúdo para ser 
    armazenado ou transmitido de forma eficiente.

    endTime: Uma propriedade de tipo Date que representa o horário de término do temporizador, definida 
    como uma propriedade dentro da estrutura ContentState.

    A estrutura TimerAttributes é projetada para ser usada em conjunto com o ActivityKit para 
    criar e gerenciar atividades interativas baseadas em temporizadores em um aplicativo. Pode ser 
    usada para definir os atributos de uma atividade de temporizador, como o nome do temporizador e o 
    horário de término, que podem ser usados para criar e gerenciar uma experiência de atividade 
    interativa para os usuários.
*/