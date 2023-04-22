import SwiftUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
            return UISceneConfiguration(
                name: "Default Configuration",
                sessionRole: connectingSceneSession.role
            )
    }
}

/*
    O método de delegação application(_:configurationForConnecting:options:) do protocolo 
    UIApplicationDelegate. Esse método é responsável por criar e retornar uma configuração de cena para 
    uma sessão de cena que está sendo conectada. Nesse caso, o método simplesmente retorna uma 
    configuração de cena padrão com o nome "Default Configuration" e o papel da sessão de conexão 
    especificado pela sessão de cena conectada. Isso é útil para aplicativos simples que usam apenas uma 
    cena e não precisam de configurações personalizadas.
*/