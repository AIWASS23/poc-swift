import WatchKit
import UserNotifications

final class ExtensionDelegate: NSObject, WKExtensionDelegate {
  func didRegisterForRemoteNotifications(withDeviceToken deviceToken: Data) {
    print(deviceToken.reduce("") { $0 + String(format: "%02x", $1) })
  }

  func applicationDidFinishLaunching() {
    Task {
      do {
        let success = try await UNUserNotificationCenter
          .current()
          .requestAuthorization(options: [.badge, .sound, .alert])

        guard success else { return }

        await MainActor.run {
          WKExtension.shared().registerForRemoteNotifications()
        }
      } catch {
        print(error.localizedDescription)
      }
    }
  }
}

/*
	Esse código implementa o delegate da extensão do WatchKit, 
	a classe ExtensionDelegate, que é responsável por lidar com eventos 
	relacionados ao ciclo de vida da extensão no Apple Watch.

	A classe ExtensionDelegate herda de NSObject e implementa o protocolo 
	WKExtensionDelegate. Isso permite que ela responda a eventos e notificações 
	específicas da extensão.

	A função didRegisterForRemoteNotifications(withDeviceToken deviceToken: Data) 
	é chamada quando o Apple Watch é registrado para receber notificações remotas. 
	Nessa implementação, o dispositivo token é recebido como um objeto Data e é 
	convertido para uma representação hexadecimal usando a função reduce. 
	A representação hexadecimal do token é então impressa no console para fins de 
	depuração ou registro.

	A função applicationDidFinishLaunching() é chamada quando a extensão do 
	WatchKit é iniciada. Nessa implementação, é usado o async/await para solicitar 
	a autorização do usuário para exibir notificações remotas usando o 
	UNUserNotificationCenter. As opções de autorização .badge, .sound e .alert 
	são especificadas. O resultado da solicitação de autorização é armazenado na 
	constante success.

	Se a solicitação de autorização for bem-sucedida (success é true), é usado o 
	MainActor.run para executar ações relacionadas à interface do usuário na thread 
	principal. Dentro desse bloco, o método registerForRemoteNotifications() é 
	chamado na instância compartilhada de WKExtension. Isso registra o Apple Watch 
	para receber notificações remotas.

	Se a solicitação de autorização falhar ou não for bem-sucedida, um possível 
	erro é capturado e sua descrição é impressa no console.
*/