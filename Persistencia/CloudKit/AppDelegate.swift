import CloudKit
import SwiftUI

final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let sceneConfig = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        sceneConfig.delegateClass = SceneDelegate.self
        return sceneConfig
    }
}

/*
    A classe AppDelegate é responsável por configurar a cena (scene) usada pelo aplicativo quando 
    o usuário se conecta a um compartilhamento CloudKit. Isso é feito por meio do método 
    application(_:configurationForConnecting:options:), que retorna uma configuração de cena 
    (scene configuration) com uma referência à classe SceneDelegate.

*/

final class SceneDelegate: NSObject, UIWindowSceneDelegate {
    func windowScene(_ windowScene: UIWindowScene, userDidAcceptCloudKitShareWith cloudKitShareMetadata: CKShare.Metadata) {
        let shareStore = CoreDataStack.shared.sharedPersistentStore
        let persistentContainer = CoreDataStack.shared.persistentContainer
        persistentContainer.acceptShareInvitations(from: [cloudKitShareMetadata], into: shareStore) { _, error in
            if let error = error {
                print("acceptShareInvitation error :\(error)")
            }
        }
    }
}

/*

    A classe SceneDelegate é responsável por aceitar um convite para compartilhamento do CloudKit. Isso é 
    feito por meio do método windowScene(_:userDidAcceptCloudKitShareWith:), que recebe metadados do 
    compartilhamento e, em seguida, aceita o convite para compartilhar dados do CloudKit na loja de 
    dados compartilhados (shared data store) do aplicativo. A loja de dados compartilhados é obtida a 
    partir da propriedade sharedPersistentStore do objeto CoreDataStack.shared. Em caso de erro, o método 
    exibe uma mensagem de erro na console do Xcode.

*/