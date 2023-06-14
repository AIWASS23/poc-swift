import WatchKit
import SwiftUI
import UserNotifications

class NotificationController: WKUserNotificationHostingController<NotificationView> {
  var image: Image!
  var message: String!

  override var body: NotificationView {
    return NotificationView(message: message, image: image)
  }

  override func didReceive(_ notification: UNNotification) {
    let content = notification.request.content
    message = content.body

    let validRange = 1...20

    if let imageNumber = content.userInfo["imageNumber"] as? Int, 
			validRange ~= imageNumber {
			// O operador ~= é o operador de verificação de pertencimento em Swift. 
			// Ele é usado para testar se um valor está contido em um intervalo, 
			// uma sequência ou em um tipo que implemente o protocolo RangeExpression.

	      image = Image("Mandala\(imageNumber)")
    } else {
      let num = Int.random(in: validRange)
      image = Image("Mandala\(num)")
    }
  }
}

/*
	Esse código implementa um controlador de notificação para um aplicativo 
	WatchKit usando SwiftUI. A classe NotificationController herda de 
	WKUserNotificationHostingController e é responsável por exibir uma 
	notificação no Apple Watch.

	A classe NotificationController possui duas propriedades: image e message. 
	A propriedade image é do tipo Image e armazena a imagem que será exibida na 
	notificação. A propriedade message é do tipo String e armazena a mensagem da 
	notificação.

	A função body é sobrescrita para retornar uma instância de NotificationView, 
	que é uma visualização personalizada que será exibida para a notificação.

	A função didReceive(_ notification: UNNotification) é chamada quando uma nova 
	notificação é recebida. Dentro dessa função, as informações da notificação são 
	extraídas do objeto UNNotification e atribuídas às propriedades message e image.

	A mensagem da notificação é obtida do conteúdo da notificação. A imagem da 
	notificação é obtida das informações do usuário associadas à notificação. Se 
	um número de imagem válido estiver presente nas informações do usuário 
	(entre 1 e 20, inclusive), a imagem correspondente é atribuída à propriedade 
	image. Caso contrário, um número de imagem aleatório dentro do intervalo 
	válido é gerado e a imagem correspondente é atribuída.
*/