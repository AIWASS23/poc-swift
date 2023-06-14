import Foundation
import UserNotifications

final class LocalNotifications: NSObject {
  static let categoryIdentifier = "Mandala"

  private let actionIdentifier = "action"

  override init() {
    super.init()

    Task {
      do {
        try await self.register()
        try await self.schedule()
      } catch {
        print("⌚️ local notification: \(error.localizedDescription)")
      }
    }
  }

  func register() async throws {
    let current = UNUserNotificationCenter.current()
    try await current.requestAuthorization(options: [.alert, .sound])

    current.removeAllPendingNotificationRequests()

    let action = UNNotificationAction(
      identifier: self.actionIdentifier,
      title: "Mandala",
      options: .foreground)

    let category = UNNotificationCategory(
      identifier: Self.categoryIdentifier,
      actions: [action],
      intentIdentifiers: [])

    current.setNotificationCategories([category])
    current.delegate = self
  }

  func schedule() async throws {
    let current = UNUserNotificationCenter.current()
    let settings = await current.notificationSettings()
    guard settings.alertSetting == .enabled else { return }

    let content = UNMutableNotificationContent()
    content.title = "Mandala"
    content.subtitle = "Guess what time it is"
    content.body = "Mandala Time"
    content.categoryIdentifier = Self.categoryIdentifier

    let components = DateComponents(minute: 30)
    let trigger = UNCalendarNotificationTrigger(
      dateMatching: components,
      repeats: true)

    let request = UNNotificationRequest(
      identifier: UUID().uuidString,
      content: content,
      trigger: trigger)

    try await current.add(request)
  }
}

extension LocalNotifications: UNUserNotificationCenterDelegate {
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
    return [.list, .sound]
  }
}

/*
	Esse codigo implementa um gerenciador de notificações locais usando a classe 
	UNUserNotificationCenter do framework UserNotifications do iOS. Ele define uma 
	classe chamada LocalNotifications que é responsável por registrar, agendar e 
	lidar com notificações locais.

	A classe LocalNotifications herda de NSObject e é marcada como final, o que 
	significa que ela não pode ser herdada. Ela possui uma propriedade estática 
	chamada categoryIdentifier, que é um identificador para a categoria de 
	notificação.

	A classe também possui uma propriedade actionIdentifier, que é um identificador 
	para uma ação de notificação específica. Nesse caso, a ação é chamada de "action" 
	e é exibida como "Mandala!" no alerta da notificação.

	No método init, o registro e o agendamento das notificações são realizados 
	assincronamente. É usada a nova sintaxe async/await introduzida no Swift para 
	lidar com operações assíncronas de forma mais concisa. Dentro do bloco Task, 
	primeiro é feito o registro para obter a autorização do usuário para exibir 
	notificações do tipo alerta e som. Em seguida, todas as solicitações de 
	notificação pendentes são removidas.

	Em seguida, uma ação de notificação e uma categoria de notificação são criadas. 
	A ação de notificação permite que o usuário abra o aplicativo quando a 
	notificação é selecionada, e a categoria de notificação associa a ação à 
	categoria Mandala. As categorias de notificação permitem agrupar diferentes 
	tipos de ações para notificações.

	O método schedule é responsável por agendar a notificação. Ele verifica as 
	configurações de notificação do usuário e, se as configurações de alerta 
	estiverem habilitadas, cria uma instância de UNMutableNotificationContent para 
	definir o título, subtítulo e corpo da notificação. O identificador da categoria 
	de notificação também é atribuído à notificação para associá-la à categoria 
	Mandala.

	Em seguida, é criado um UNCalendarNotificationTrigger que dispara a notificação 
	a cada 30 minutos, e uma solicitação de notificação é criada usando um 
	identificador único gerado pelo UUID. A solicitação de notificação é adicionada 
	ao centro de notificação.

	A classe LocalNotifications também implementa a extensão 
	UNUserNotificationCenterDelegate, que lida com a apresentação de notificações 
	quando o aplicativo está em primeiro plano. 
	O método userNotificationCenter(_:willPresent:completionHandler:) é chamado 
	quando uma notificação é recebida e está prestes a ser apresentada ao usuário. 
	Nesse método, é especificado que a notificação deve ser apresentada com opções 
	de .list (para exibir a notificação na lista de notificações do dispositivo) e 
	.sound (para reproduzir o som associado à notificação).

*/