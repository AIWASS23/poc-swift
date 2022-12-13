import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Ponto de sobrescrita para customização após o launch do aplicativo.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        /* 
            Chamado quando uma nova sessão de cena está sendo criada.
            Use este método para selecionar uma configuração para criar a nova cena.
        */
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        /*
            Chamado quando o usuário descarta uma sessão de cena.
            Se alguma sessão foi descartada enquanto o aplicativo não estava em execução, 
            isso será chamado logo após application:didFinishLaunchingWithOptions.
            Use este método para liberar quaisquer recursos específicos das cenas descartadas, 
            pois elas não retornarão.
        */
    }


}

