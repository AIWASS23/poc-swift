import WatchKit
import SwiftUI
import UserNotifications

final class RemoteNotificationController: WKUserNotificationHostingController<RemoteNotificationView> {
	static let categoryIdentifier = "lorem"
  
  private var model: RemoteNotificationModel!
  
  override class var isInteractive: Bool { true}
  
  override var body: RemoteNotificationView {
    return RemoteNotificationView(model: model)
  }
  
  override func didReceive(_ notification: UNNotification) {
    let fmt = ISO8601DateFormatter()
    
    let content = notification.request.content
    let title = content.title
    let body = content.body
    
    guard
      let dateString = content.userInfo["date"] as? String,
      let date = fmt.date(from: dateString)
    else {
      model = RemoteNotificationModel(
        title: "Unknown",
        details: "Unknown",
        date: Date.now
      )
      
      return
    }
    
    model = RemoteNotificationModel(title: title, details: body, date: date)
  }
}

/*
	Essa é uma implementação de um controlador de notificação remota para um 
	aplicativo WatchKit usando SwiftUI. Ele estende a classe WKUserNotificationHostingController 
	e define uma classe chamada RemoteNotificationController.

	A classe RemoteNotificationController é definida como final, o que significa 
	que ela não pode ser herdada. Ela é um controlador responsável por exibir uma 
	notificação remota no Apple Watch.

	A classe tem uma propriedade estática categoryIdentifier, que é um 
	identificador para a categoria de notificação. Esse identificador pode ser 
	usado para agrupar diferentes tipos de notificações em categorias específicas.

	A classe também possui uma propriedade model, que é uma instância da classe 
	RemoteNotificationModel. O modelo é usado para armazenar as informações da 
	notificação, como o título, os detalhes e a data.

	A função isInteractive é sobrescrita para retornar true. Isso indica que o 
	controlador é interativo e pode responder a interações do usuário.

	A função body é sobrescrita para retornar uma instância de 
	RemoteNotificationView, que é uma visualização que será exibida para a 
	notificação remota.

	A função didReceive(_ notification: UNNotification) é chamada quando uma nova 
	notificação remota é recebida. Dentro dessa função, as informações da 
	notificação são extraídas do objeto UNNotification e atribuídas ao modelo 
	RemoteNotificationModel. O título e o corpo da notificação são obtidos do 
	conteúdo da notificação, e a data é extraída das informações do usuário 
	associadas à notificação.

	Se a extração das informações falhar, um valor padrão é atribuído ao modelo.

*/