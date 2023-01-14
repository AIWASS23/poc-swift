import CodeScanner // Package https://github.com/twostraws/CodeScanner
import SwiftUI

/*
    UserNotifications é um framework do iOS e macOS que permite que os desenvolvedores enviem notificações 
    push para os usuários. Ele fornece uma interface para configurar e gerenciar notificações, incluindo 
    conteúdo, triggers e ações de resposta. Com o UserNotifications, os desenvolvedores podem agendar 
    notificações para serem enviadas em uma data específica, ou quando um determinado evento ocorrer, 
    como a chegada de um novo e-mail ou mensagem. Além disso, os desenvolvedores também podem adicionar 
    ações personalizadas às notificações, permitindo que os usuários tomem medidas diretamente a partir 
    da notificação, sem precisar abrir o aplicativo.
*/
import UserNotifications

struct ProspectsView: View {
    enum FilterType {
        case none
        case contacted
        case uncontacted
    }

    @EnvironmentObject var prospects: Prospects
    @State private var isShowingScanner = false

    let filter: FilterType

    var body: some View {
        NavigationView {
            List {
                ForEach(filteredProspects) { prospect in
                    VStack(alignment: .leading) {
                        Text(prospect.name)
                            .font(.headline)
                        Text(prospect.emailAddress)
                            .foregroundColor(.secondary)
                    }
                    .swipeActions {

                        /*
                            swipeActions é uma propriedade do SwiftUI que é usada para adicionar ações de 
                            deslizar às células de uma List ou UITableView. Ele permite que o usuário 
                            deslize para a esquerda ou para a direita em uma célula para revelar uma 
                            série de ações, como excluir ou marcar como concluído. Essas ações são 
                            definidas como um array de botões SwipeAction, cada um dos quais pode ter um 
                            título, uma imagem e uma ação a ser executada quando for tocado. É uma forma de 
                            fornecer acesso rápido a ações importantes para os usuários, sem precisar usar 
                            botões ou outros elementos de interface na célula.
                        */

                        if prospect.isContacted {
                            Button {
                                prospects.toggle(prospect)
                            } label: {
                                Label("Mark Uncontacted", systemImage: "person.crop.circle.badge.xmark")
                            }
                            .tint(.blue)
                        } else {
                            Button {
                                prospects.toggle(prospect)
                            } label: {
                                Label("Mark Contacted", systemImage: "person.crop.circle.fill.badge.checkmark")
                            }
                            .tint(.green)

                            Button {
                                addNotification(for: prospect)
                            } label: {
                                Label("Remind Me", systemImage: "bell")
                            }
                            .tint(.orange)
                        }
                    }
                }
            }
            .navigationTitle(title)
            .toolbar {
                Button {
                    isShowingScanner = true
                } label: {
                    Label("Scan", systemImage: "qrcode.viewfinder")
                }
            }
            .sheet(isPresented: $isShowingScanner) {
                CodeScannerView(codeTypes: [.qr], simulatedData: "Paul Hudson\npaul@hackingwithswift.com", completion: handleScan)
            }
        }
    }

    var title: String {
        switch filter {
        case .none:
            return "Everyone"
        case .contacted:
            return "Contacted people"
        case .uncontacted:
            return "Uncontacted people"
        }
    }

    var filteredProspects: [Prospect] {
        switch filter {
        case .none:
            return prospects.people
        case .contacted:
            return prospects.people.filter { $0.isContacted }

            /*
                filter é um método de coleção do Swift que é usado para criar um novo array ou coleção com 
                elementos que satisfazem um determinado critério. Ele é usado para filtrar elementos de uma 
                coleção base, com base em uma condição específica. Ele é uma função de alta ordem, o que 
                significa que ele toma uma função como parâmetro e aplica essa função a cada elemento da 
                coleção. A função deve retornar true ou false para cada elemento, indicando se o elemento 
                deve ser incluído ou excluído da coleção resultante. Exemplo:

                let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
                let evenNumbers = numbers.filter { $0 % 2 == 0 }
                print(evenNumbers) // [2, 4, 6, 8, 10]
            */
        case .uncontacted:
            return prospects.people.filter { !$0.isContacted }
        }
    }

    func handleScan(result: Result<ScanResult, ScanError>) {

        /*
            Result é uma enumeração do Swift que fornece um tipo seguro para representar um resultado de 
            uma operação que pode ser bem-sucedido ou falhar. Ele é definido na biblioteca do Swift 
            standard e é parte do pacote de resultados do Swift 5.0. Ele é usado para representar o 
            resultado de uma operação que pode falhar, como uma operação de rede ou de leitura de arquivo. 
            Ele tem dois casos: .success e .failure, que representam o sucesso ou falha de uma operação. 
            Ele é uma alternativa ao uso de exceções para lidar com erros. Ao usar Result, você pode 
            lidar com erros de forma mais segura e clara, facilitando a manutenção do código.
        */

        isShowingScanner = false

        switch result {
        case .success(let result):
            let details = result.string.components(separatedBy: "\n")
            guard details.count == 2 else { return }

            let person = Prospect()
            person.name = details[0]
            person.emailAddress = details[1]
            prospects.add(person)
        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
    }

    func addNotification(for prospect: Prospect) {

        /*
            UNUserNotificationCenter é uma classe do iOS e macOS que fornece uma interface para gerenciar 
            notificações push no sistema. Ele é parte do framework UserNotifications e é usado para 
            configurar e gerenciar notificações, incluindo conteúdo, triggers e ações de resposta. Ele 
            também permite que os desenvolvedores acessem informações sobre as notificações que foram 
            entregues, rejeitadas ou exibidas para o usuário. Com essa classe, os desenvolvedores podem 
            agendar notificações para serem enviadas em uma data específica, ou quando um determinado 
            evento ocorrer. Além disso, os desenvolvedores também podem adicionar ações personalizadas às 
            notificações, permitindo que os usuários tomem medidas diretamente a partir da notificação.
        */

        let center = UNUserNotificationCenter.current()

        let addRequest = {

            /*
                UNMutableNotificationContent é uma classe do iOS e macOS do framework UserNotifications que 
                é usada para criar e configurar o conteúdo de uma notificação push. Ele é uma subclasse de 
                UNNotificationContent e permite que os desenvolvedores configurem diferentes aspectos da 
                notificação, como título, subtítulo, mensagem, anexos, entre outros. Ele também permite 
                aos desenvolvedores adicionar ações personalizadas à notificação. Uma vez configurado, 
                o objeto de conteúdo pode ser adicionado a um objeto de UNNotificationRequest e agendado 
                usando o UNUserNotificationCenter. Exemplo:

                let content = UNMutableNotificationContent()
                content.title = "Lembrete"
                content.subtitle = "Tarefa importante"
                content.body = "Não esqueça de fazer a tarefa importante hoje"
                content.badge = 1
            */

            let content = UNMutableNotificationContent()

            /*
                UNMutableNotificationContent é uma classe do framework UserNotifications do iOS que permite 
                criar conteúdo para notificações locais e remotas. Ele fornece uma variedade de 
                propriedades para configurar o conteúdo da notificação, como título, corpo, anexos e 
                dados adicionais. Exemplo:

                let content = UNMutableNotificationContent()
                content.title = "Lembrete"
                content.body = "Não se esqueça de comprar leite hoje"
                content.sound = UNNotificationSound.default

                Em seguida, você pode atribuir o objeto UNMutableNotificationContent criado ao objeto 
                UNNotificationRequest, que é o objeto responsável por agendar a notificação.

                let request = UNNotificationRequest(
                    identifier: "LembreteDeComprarLeite", 
                    content: content, 
                    trigger: nil)

                E finalmente agendar a notificação

                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            */
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.emailAddress
            content.sound = UNNotificationSound.default

            /*
                UNNotificationSound é uma enumeração do framework UserNotifications do iOS que permite 
                especificar o som que será reproduzido quando a notificação for exibida. Ele inclui 
                valores pré-definidos para os sons padrão do sistema, como .default, .none e também é 
                possível especificar um som personalizado com um arquivo de som. Exemplo:

                let content = UNMutableNotificationContent()
                content.title = "Lembrete"
                content.body = "Não se esqueça de comprar leite hoje"
                content.sound = UNNotificationSound.default

                ou

                content.sound = UNNotificationSound(
                    named: UNNotificationSoundName(rawValue: "customSound.caf"))

                Note que para utilizar um som personalizado, você precisa incluir o arquivo de som em 
                seu projeto e especificar o caminho do arquivo no construtor.
            */

            var dateComponents = DateComponents()

            /*
                DateComponents é uma classe do framework Foundation do iOS que representa uma data com 
                componentes separados, como ano, mês, dia, hora, minuto e segundo. Ele permite criar uma 
                data a partir de componentes individuais ou extrair componentes de uma data existente. Exemplo:

                // Criando uma data com componentes
                let dateComponents = DateComponents(
                    calendar: Calendar.current, 
                    year: 2021, 
                    month: 12, 
                    day: 25)

                let date = dateComponents.date

                // Extraindo componentes de uma data existente

                let date = Date()
                let calendar = Calendar.current
                let year = calendar.component(.year, from: date)
                let month = calendar.component(.month, from: date)
                let day = calendar.component(.day, from: date)

                Você também pode usar o método date(from:) da classe Calendar para criar uma data a 
                partir de componentes:

                let date = Calendar.current.date(from: dateComponents)

                Além disso, pode-se utilizar o método dateComponents(_:from:) da classe Calendar 
                para extrair componentes de uma data existente:

                let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: date)
            */

            dateComponents.hour = 9
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

            /*
                UNTimeIntervalNotificationTrigger é uma classe do framework UserNotifications do iOS que 
                permite agendar uma notificação para ser exibida após um intervalo de tempo específico. 
                Ele é inicializado com um tempo em segundos e é usado para criar um gatilho para uma 
                notificação. Exemplo:

                let content = UNMutableNotificationContent()
                content.title = "Lembrete"
                content.body = "Não se esqueça de comprar leite hoje"
                content.sound = UNNotificationSound.default

                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: false)
                let request = UNNotificationRequest(
                    identifier: "LembreteDeComprarLeite", 
                    content: content, 
                    trigger: trigger)

                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)

                Neste exemplo acima, a notificação será exibida após 60 segundos e não será repetida.
                Você pode também usar a classe UNCalendarNotificationTrigger ou 
                UNLocationNotificationTrigger para agendar notificações baseadas em uma data ou em uma 
                localização específica.
            */

            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

            /*
                UNNotificationRequest é uma classe do framework UserNotifications do iOS que representa 
                uma notificação agendada. Ele é inicializado com um identificador único, o conteúdo da 
                notificação (instância de UNNotificationContent) e o gatilho (instância de 
                UNNotificationTrigger) que determina quando a notificação será exibida. Exemplo:

                let content = UNMutableNotificationContent()
                content.title = "Lembrete"
                content.body = "Não se esqueça de comprar leite hoje"
                content.sound = UNNotificationSound.default

                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: false)
                let request = UNNotificationRequest(
                    identifier: "LembreteDeComprarLeite", 
                    content: content, 
                    trigger: trigger)

                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)

                Aqui um objeto UNNotificationRequest é criado com um identificador único 
                "LembreteDeComprarLeite", o conteúdo da notificação e o gatilho que a fará ser exibida 
                após 60 segundos. Este objeto é então adicionado à instância de UNUserNotificationCenter 
                para ser agendado.

                A classe UNNotificationRequest também fornece métodos para remover notificações agendadas, 
                como: 
                removePendingNotificationRequests(withIdentifiers:)
                removeDeliveredNotifications(withIdentifiers:).
            */

            center.add(request)
        }

        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        addRequest()
                    } else {
                        print("D'oh!")
                    }
                }
            }
        }
    }
}

struct ProspectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectsView(filter: .none)
            .environmentObject(Prospects())
    }
}
