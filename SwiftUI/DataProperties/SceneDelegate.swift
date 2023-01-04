import CoreData
import SwiftUI
import UIKit

/*
    Esse script é usado para configurar a interface do usuário do aplicativo usando o framework SwiftUI. 
    Ele define a classe SceneDelegate, que é uma classe do UIKit responsável por gerenciar o 
    ciclo de vida de uma cena (scene) em um aplicativo iOS.

    A classe SceneDelegate é derivada de UIResponder e implementa o protocolo UIWindowSceneDelegate. 
    Isso significa que ela pode ser usada como um delegate para receber eventos de cena do 
    sistema operacional e atuar em conformidade.

    A classe SceneDelegate tem uma propriedade "window" do tipo UIWindow, que é a janela principal 
    da interface do usuário do aplicativo. Quando a cena é conectada à sessão, 
    a função scene(_:willConnectTo:options:) é chamada pelo sistema operacional. 
    Essa função configura o contexto de persistência do aplicativo e cria a 
    interface do usuário do aplicativo usando o framework SwiftUI.

    A função scene(_:willConnectTo:options:) começa obtendo o contexto de visualização (view context) 
    da instância da classe NSPersistentContainer criada anteriormente no AppDelegate. 
    Em seguida, a função define a política de mesclagem do contexto de visualização 
    como NSMergeByPropertyObjectTrumpMergePolicy. Isso significa que, se o contexto de 
    visualização tiver alterações em conflito com alterações no armazenamento persistente, 
    as alterações no contexto de visualização são mantidas e as alterações no armazenamento 
    persistente são descartadas.

    Em seguida, a função cria uma instância da vista principal da interface do usuário do 
    aplicativo usando o framework SwiftUI. Essa instância é criada passando o 
    contexto de visualização como um ambiente para a vista. Em seguida, a função cria uma 
    janela do UIKit e define a vista principal da interface do usuário como a 
    raiz da janela usando um controlador de hospedagem (hosting controller). 
    Por fim, a função torna a janela visível e a torna a janela ativa.

    A classe SceneDelegate também implementa várias outras funções de delegate para 
    receber eventos de cena do sistema operacional. Por exemplo, quando a 
    cena entra em segundo plano, a função sceneDidEnterBackground(_:) é chamada. 
    Nessa função, o contexto de visualização é salvo para que as alterações 
    pendentes sejam persistidas permanentemente no armazenamento persistente.
*/

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    /*
        UIWindowSceneDelegate é um protocolo do UIKit que define métodos que permitem 
        gerenciar os eventos de uma cena de interface do usuário. Ele é usado principalmente para 
        gerenciar a vida útil de uma cena de interface do usuário e para fazer transições entre cenas.

        Para implementar o protocolo UIWindowSceneDelegate, você precisa adotá-lo em sua classe e 
        implementar os métodos necessários. Aqui estão alguns dos métodos comuns que você pode implementar:

        windowScene(_:willConnectTo:options:): Este método é chamado quando a cena está prestes a 
        ser atribuída a uma janela de interface do usuário. Você pode usá-lo para configurar a 
        interface do usuário da cena.

        windowScene(_:didDisconnectFrom:): Este método é chamado quando a cena é desconexão da 
        janela de interface do usuário. Você pode usá-lo para liberar recursos ou fazer outras limpezas.

        windowScene(_:openURLContexts:): Este método é chamado quando a cena recebe um pedido 
        para abrir um conjunto de URLs. Você pode usá-lo para processar o pedido e abrir os URLs adequados.

        windowScene(_:didUpdate:): Este método é chamado quando há alterações na cena, 
        como a mudança do tamanho da janela ou a rotação do dispositivo. 
        Você pode usá-lo para atualizar a interface do usuário da cena de acordo.

        windowScene(_:didEnterBackground:): Este método é chamado quando a cena entra em segundo plano. 
        Você pode usá-lo para salvar o estado da cena ou liberar recursos para economizar bateria.

        windowScene(_:willEnterForeground:): Este método é chamado quando a cena está prestes a 
        entrar em primeiro plano. Você pode usá-lo para restaurar o estado da cena ou para se 
        preparar para a transição de volta para a interface do usuário.

        Exemplo:

        class SceneDelegate: UIResponder, UIWindowSceneDelegate {

            func windowScene(_ windowScene: UIWindowScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
                // Aqui você pode configurar a interface do usuário da cena
            }
            
            func windowScene(_ windowScene: UIWindowScene, didDisconnectFrom session: UISceneSession) {
                // Aqui você pode liberar recursos e fazer outras limpezas
            }
            
            func windowScene(_ windowScene: UIWindowScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
                // Aqui você pode processar o pedido de abertura de URLs
            }

            func windowScene(_ windowScene: UIWindowScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
                // Aqui você pode configurar a interface do usuário da cena
            }
    
            func windowScene(_ windowScene: UIWindowScene, didDisconnectFrom session: UISceneSession) {
                // Aqui você pode liberar recursos e fazer outras limpezas
            }
            
            func windowScene(_ windowScene: UIWindowScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
                // Aqui você pode processar o pedido de abertura de URLs
            }
            
            func windowScene(_ windowScene: UIWindowScene, didUpdate previousCoordinateSpace: UICoordinateSpace, interfaceOrientation previousInterfaceOrientation: UIInterfaceOrientation, traitCollection previousTraitCollection: UITraitCollection) {
                // Aqui você pode atualizar a interface do usuário da cena de acordo com as alterações na cena
            }
            
            func windowSceneDidEnterBackground(_ windowScene: UIWindowScene) {
                // Aqui você pode salvar o estado da cena ou liberar recursos para economizar bateria
            }
            
            func windowSceneWillEnterForeground(_ windowScene: UIWindowScene) {
                // Aqui você pode restaurar o estado da cena ou se preparar para a transição de volta para a interface do usuário
            }
        }
    */

    var window: UIWindow?

    /*
        UIWindow é um objeto da biblioteca UIKit que representa uma janela de interface do 
        usuário na tela do dispositivo. Ele é usado principalmente para exibir a interface do 
        usuário de uma aplicação e gerenciar o ciclo de vida de uma interface do usuário.

        Para criar uma janela de interface do usuário, você pode inicializar um objeto UIWindow e 
        atribuí-lo a uma propriedade da classe AppDelegate. Aqui está um exemplo de como fazer isso:

        import UIKit

        @UIApplicationMain
        class AppDelegate: UIResponder, UIApplicationDelegate {
            var window: UIWindow?

            func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
                // Cria a janela da interface do usuário
                let window = UIWindow(frame: UIScreen.main.bounds)
                window.rootViewController = ViewController()
                window.makeKeyAndVisible()
                self.window = window
                
                return true
            }
        }

        Depois de criar a janela, você pode configurar a interface do usuário da janela 
        atribuindo um objeto UIViewController à propriedade rootViewController da janela. 
        O objeto UIViewController é responsável por gerenciar a hierarquia de exibição da 
        interface do usuário da janela.

        Você também pode usar o objeto UIWindow para fazer transições entre interfaces do usuário. 
        Por exemplo, você pode usar o método makeKeyAndVisible() para tornar a janela visível e 
        atribuir o foco de entrada a ela. Você também pode usar o método setRootViewController(_:animated:) 
        para alterar o objeto UIViewController raiz da janela de forma animada.
    */

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        /*
            Essa função é um método do protocolo UISceneDelegate e é chamada quando uma cena está 
            prestes a ser conectada a uma sessão de interface do usuário. Ela é usada 
            principalmente para configurar a interface do usuário da cena e fazer a transição 
            para a interface do usuário quando a cena é exibida pela primeira vez.

            A função começa criando uma referência para o contexto de gerenciamento de objetos do Core Data 
            da aplicação e alterando a política de mesclagem do contexto para 
            NSMergeByPropertyObjectTrumpMergePolicy. Em seguida, ela cria uma exibição de 
            conteúdo usando a biblioteca SwiftUI e atribui o contexto de gerenciamento de objetos a 
            ele como um ambiente.

            Em seguida, a função verifica se a cena é uma cena de janela de interface do usuário 
            (UIWindowScene) e, se for, cria uma janela de interface do usuário e atribui a exibição 
            de conteúdo a ela como o controlador de visualização raiz. Depois de configurar a janela, 
            a função torna a janela visível e atribui o foco de entrada a ela.
        */

        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext


        /*
            .mergePolicy é uma propriedade do contexto de gerenciamento de objetos do Core Data que 
            determina como os conflitos de dados são resolvidos quando os dados são mesclados entre 
            contextos. A política de mesclagem é especificada por um objeto do tipo NSMergePolicy.

            Existem várias políticas de mesclagem disponíveis no Core Data, cada uma com uma abordagem 
            diferente para resolver conflitos de dados. Algumas das políticas mais comuns são:

            NSMergeByPropertyStoreTrumpMergePolicy: Sempre leva em consideração as alterações feitas 
            no banco de dados persistente. Se houver um conflito, as alterações do banco de dados 
            prevalecerão sobre as alterações feitas no contexto atual.

            NSMergeByPropertyObjectTrumpMergePolicy: Sempre leva em consideração as alterações feitas no 
            contexto atual. Se houver um conflito, as alterações do contexto atual 
            prevalecerão sobre as alterações feitas no banco de dados ou em outro contexto.

            NSOverwriteMergePolicy: Sempre substitui as alterações feitas em outro contexto 
            pelas alterações feitas no contexto atual.

            NSRollbackMergePolicy: Sempre descarta as alterações feitas no contexto atual em 
            caso de conflito.
        */

        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        let contentView = ContentView().environment(\.managedObjectContext, context)
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)

            /*
                UIHostingController é um objeto da biblioteca UIKit que exibe uma exibição da 
                biblioteca SwiftUI como parte de uma interface do usuário de aplicativo. 
                Ele é usado principalmente para integrar a biblioteca SwiftUI com a 
                interface do usuário do aplicativo e para gerenciar o ciclo de vida da exibição.

                Para usar um UIHostingController, basta inicializá-lo com uma exibição da 
                biblioteca SwiftUI e atribuí-lo a uma propriedade de exibição do aplicativo, 
                como a propriedade rootViewController de um objeto UIWindow.

                Depois de configurar o UIHostingController, ele gerenciará o ciclo de vida da 
                exibição da biblioteca SwiftUI e fará a ponte entre a interface do usuário do 
                aplicativo e a exibição. Isso significa que o UIHostingController irá gerenciar 
                eventos de layout e de atualização da exibição e também irá passar informações 
                de ambiente, como o contexto de gerenciamento de objetos, para a exibição.

                Você também pode usar o UIHostingController para fazer a transição entre exibições 
                da biblioteca SwiftUI. Por exemplo, você pode usar o método setRootView(_:) 
                para alterar a exibição raiz do UIHostingController de forma animada.
            */
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}

