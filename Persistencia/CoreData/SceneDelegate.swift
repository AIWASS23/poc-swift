import SwiftUI
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
            let context = persistentContainer.viewContext
            let contentView = MovieList().environment(\.managedObjectContext, context)

            if let windowScene = scene as? UIWindowScene {
                let window = UIWindow(windowScene: windowScene)
                window.rootViewController = UIHostingController(rootView: contentView)
                self.window = window
                window.makeKeyAndVisible()
            }
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        saveContext()
    }


    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Marcelo")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                // You should add your own error handling code here.
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

  // MARK: - Core Data Saving support

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // The context couldn't be saved.
                // You should add your own error handling here.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

/*
    O SceneDelegate que é responsável por gerenciar a cena principal de um aplicativo iOS com a estrutura
    SwiftUI. Ele implementa o protocolo UIWindowSceneDelegate para lidar com eventos de ciclo de vida da 
    cena.

    A função scene(_:willConnectTo:options:) é chamada quando a cena é carregada pela primeira vez e ela 
    instancia um contexto NSManagedObjectContext a partir do contêiner persistente. Em seguida, ele 
    cria uma instância de MovieList (uma exibição SwiftUI) e a envolve com o contexto gerenciado.

    Em seguida, ele cria uma janela, define a MovieList como sua visualização raiz usando um 
    UIHostingController e a exibe.

    A função sceneDidEnterBackground(_:) é chamada quando o aplicativo entra em segundo plano e chama a 
    função saveContext() para salvar qualquer mudança pendente no contexto.

    A variável persistentContainer define um contêiner persistente NSPersistentContainer que é carregado 
    com um modelo de dados chamado "FaveFlicks".

    Por fim, a função saveContext() salva o contexto gerenciado se ele tiver mudanças pendentes e trata 
    erros caso ocorra uma falha na salvamento.
*/