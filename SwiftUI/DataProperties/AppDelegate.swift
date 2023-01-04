import UIKit
import CoreData

/*
    A classe AppDelegate é um ponto de entrada importante para um aplicativo iOS e é 
    responsável por gerenciar o ciclo de vida do aplicativo.

    A classe AppDelegate implementa o protocolo UIApplicationDelegate, que define métodos 
    que são chamados em diferentes momentos durante o ciclo de vida do aplicativo. 
    Por exemplo, o método "application(:didFinishLaunchingWithOptions:)" 
    é chamado quando o aplicativo é iniciado, enquanto o método "applicationDidEnterBackground(:)" 
    é chamado quando o aplicativo é enviado para segundo plano.

    A classe AppDelegate também define uma propriedade lazy chamada "persistentContainer", 
    que é uma instância de NSPersistentContainer. O NSPersistentContainer é um objeto que gerencia o 
    ciclo de vida de um conjunto de objetos gerenciados pelo Core Data, 
    incluindo o banco de dados que armazena esses objetos. 
    A propriedade "persistentContainer" é usada para carregar o banco de dados do aplicativo 
    e para salvar as alterações nos objetos gerenciados pelo Core Data quando necessário.
*/

@UIApplicationMain

/*
    @UIApplicationMain é uma anotação de classe em Swift que indica que a classe anotada é a 
    classe principal do aplicativo. A anotação @UIApplicationMain é usada para informar ao 
    compilador que essa classe deve ser usada como ponto de entrada principal para o aplicativo.
*/
class AppDelegate: UIResponder, UIApplicationDelegate {

    /*
        UIResponder é uma classe abstrata em Swift que define um comportamento padrão para 
        objetos que podem responder a eventos de toque na interface do usuário de um aplicativo iOS. 
        A classe UIResponder é a base para classes como UIView, UIViewController e UIWindow, 
        que todas herdam de UIResponder e adicionam comportamento adicional para lidar com 
        eventos de toque específicos.

        A classe UIResponder possui métodos que permitem aos objetos que a herdam gerenciar 
        eventos de toque, como toques simples, arrastar, pincar e toques longos. Esses métodos incluem:
        touchesBegan(:with:)
        touchesMoved(:with:) 
        touchesEnded(:with:) 
        touchesCancelled(:with:)

        UIApplicationDelegate é um protocolo em Swift que define métodos que são chamados em 
        diferentes momentos durante o ciclo de vida de um aplicativo iOS. 
        A classe que implementa o protocolo UIApplicationDelegate é conhecida como a 
        classe "delegada da aplicação" e é responsável por gerenciar o ciclo de vida do aplicativo.

        O protocolo UIApplicationDelegate define métodos que são chamados em vários momentos 
        importantes durante o ciclo de vida de um aplicativo, como quando o aplicativo é iniciado, 
        quando ele entra em segundo plano e quando ele é encerrado. 
        application(:didFinishLaunchingWithOptions:)" é chamado quando o aplicativo é iniciado, 
        applicationDidEnterBackground(:) é chamado quando o aplicativo é enviado para segundo plano.


    */

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        /*
            Esta é uma função que faz parte do protocolo UIApplicationDelegate em Swift. 
            A função "application(_:didFinishLaunchingWithOptions:)" é chamada quando o aplicativo é iniciado 
            e é usada para configurar o aplicativo e prepará-lo para a execução.

            A função recebe dois parâmetros:

            application é uma instância da classe UIApplication que representa o aplicativo sendo iniciado.

            launchOptions é um dicionário opcional de opções de lançamento que podem ser usadas 
            para personalizar o comportamento do aplicativo quando ele é iniciado. 
            Por exemplo, as opções de lançamento podem incluir informações sobre qual URL 
            foi usado para iniciar o aplicativo ou qual recurso do sistema deve ser exibido quando o 
            aplicativo é iniciado.

            A função deve retornar um valor Bool que indica se o aplicativo foi iniciado com êxito. 
            Se a função retornar "true", o aplicativo será iniciado normalmente. 
            Se a função retornar "false", o aplicativo não será iniciado 
            e o sistema exibirá uma mensagem de erro para o usuário.
        */
        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {

        /*
            Essa é uma função que faz parte do protocolo UIApplicationDelegate em Swift. 
            A função "application(_:configurationForConnecting:options:)" é chamada quando o sistema está 
            iniciando uma nova sessão de cena (scene session) para o aplicativo. 
            Uma sessão de cena é um objeto que representa um conjunto de cenas (scenes) 
            que são exibidas pelo aplicativo em determinado momento.

            A função recebe três parâmetros:

            application é uma instância da classe UIApplication que representa o aplicativo que 
            está sendo iniciado.

            connectingSceneSession é uma instância da classe UISceneSession que representa a 
            nova sessão de cena que está sendo iniciada pelo sistema.

            options é uma instância da classe UIScene.ConnectionOptions que contém opções de 
            conexão que podem ser usadas para personalizar o comportamento da sessão de cena.

            A função deve retornar uma instância da classe UISceneConfiguration que define a 
            configuração da sessão de cena. A configuração da sessão de cena inclui informações 
            como o nome da sessão de cena e o papel da sessão de cena 
            (por exemplo, se a sessão de cena é uma janela principal ou uma janela secundária).
        */
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)

        /*
            UISceneConfiguration é uma classe em Swift que define a configuração de uma sessão de cena 
            (scene session) em um aplicativo iOS. A sessão de cena é um objeto que representa um 
            conjunto de cenas (scenes) que são exibidas pelo aplicativo em determinado momento. 
            A configuração da sessão de cena inclui informações como o nome da sessão de cena, 
            o papel da sessão de cena (por exemplo, se a sessão de cena é uma janela principal ou uma janela secundária) 
            e as opções de conexão da sessão de cena.

            A classe UISceneConfiguration possui várias propriedades que podem ser usadas para obter e 
            configurar a configuração da sessão de cena. Por exemplo, 
            a propriedade "name" pode ser usada para obter ou definir o nome da sessão de cena, 
            enquanto a propriedade "sessionRole" pode ser usada para obter ou definir o papel da 
            sessão de cena.

            A classe UISceneConfiguration também possui vários métodos que podem ser usados 
            para criar e personalizar a configuração da sessão de cena. Por exemplo, o método 
            init(name:sessionRole:) pode ser usado para criar uma nova 
            instância da classe UISceneConfiguration com um nome e um papel específicos, 
            enquanto o método copy(with:) pode ser usado para criar uma cópia da configuração da 
            sessão de cena com opções adicionais.

            A classe UISceneConfiguration é usada principalmente pelo aplicativo para configurar a 
            sessão de cena quando ela é iniciada pelo sistema. A configuração da sessão de cena também 
            pode ser usada pelo sistema para determinar como o aplicativo deve se comportar 
            quando a sessão de cena é ativada ou desativada.
        */
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {

        /*
            Essa é uma função que faz parte do protocolo UIApplicationDelegate em Swift. 
            A função "application(_:didDiscardSceneSessions:)" é chamada pelo sistema quando 
            uma ou mais sessões de cena (scenes sessions) são descartadas pelo aplicativo. 
            Isso pode acontecer, por exemplo, quando o usuário fecha uma janela de cena ou quando o 
            aplicativo é enviado para segundo plano e o sistema precisa liberar recursos.

            A função recebe dois parâmetros:

            application é uma instância da classe UIApplication que representa o aplicativo 
            que está descartando as sessões de cena.

            sceneSessions é um conjunto (set) de instâncias da classe UISceneSession que 
            representam as sessões de cena que estão sendo descartadas pelo aplicativo.

            A função não tem retorno e é usada principalmente para limpar ou liberar recursos 
            quando as sessões de cena são descartadas. Por exemplo, a função pode ser usada para 
            salvar o estado do aplicativo ou para liberar recursos de memória ou de armazenamento.
        */
    }

    lazy var persistentContainer: NSPersistentContainer = {

        /*
            Esse script cria uma instância da classe NSPersistentContainer em Swift. 
            A classe NSPersistentContainer é usada para gerenciar o ciclo de vida de um conjunto de 
            objetos Core Data em um aplicativo iOS.

            A instância da classe NSPersistentContainer é criada como uma propriedade 
            "lazy" da classe AppDelegate. Isso significa que a instância da classe NSPersistentContainer 
            só é criada quando ela é realmente usada pela primeira vez. 
            Isso é útil porque a criação de uma instância da classe NSPersistentContainer 
            pode ser um processo demorado e requerer alguns recursos do sistema.

            A instância da classe NSPersistentContainer é criada com um nome de "DataProperties". 
            Isso é usado para carregar o modelo de dados Core Data que foi criado para o aplicativo. 
            O modelo de dados é um conjunto de entidades, atributos e relacionamentos que 
            descrevem os dados que o aplicativo precisa armazenar e como esses dados são relacionados.

            Quando a instância da classe NSPersistentContainer é criada, o método 
            "loadPersistentStores(completionHandler:)" é chamado para carregar o 
            modelo de dados e os dados persistentes armazenados em disco. 
            O parâmetro "completionHandler" é um bloco de código que é chamado quando o 
            carregamento é concluído. Se o carregamento for bem-sucedido, o parâmetro "error" 
            é nulo e a instância da classe NSPersistentContainer está pronta para ser usada pelo aplicativo. 
            Se ocorrer um erro durante o carregamento, o parâmetro "error" contém uma instância da classe NSError 
            com informações sobre o erro.
        */
        let container = NSPersistentContainer(name: "DataProperties")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext () {

        /*
            Essa função é usada para salvar as alterações feitas no contexto de persistência do aplicativo. 
            O contexto de persistência é um objeto que gerencia o ciclo de vida dos objetos Core Data no 
            aplicativo. Quando você cria, atualiza ou exclui objetos Core Data no aplicativo, essas 
            alterações são mantidas em memória no contexto de persistência até que sejam salvas 
            permanentemente no armazenamento persistente.

            A função começa obtendo o contexto de visualização (view context) da instância da classe 
            NSPersistentContainer criada anteriormente. O contexto de visualização é um contexto de 
            persistência especial que é usado principalmente para exibir os dados do aplicativo na 
            interface do usuário.

            Em seguida, a função verifica se o contexto de visualização tem alterações pendentes 
            usando a propriedade "hasChanges". Se houver alterações pendentes, a função chama o método 
            save() do contexto de visualização para salvar as alterações permanentemente. 
            O método save() pode lançar uma exceção se ocorrer um erro durante o 
            salvamento das alterações, por isso é necessário usar o comando try e 
            tratar qualquer exceção lançada.

            Se ocorrer um erro durante o salvamento das alterações, a função lança uma exceção fatalError 
            com uma mensagem de erro. Isso interrompe a execução do aplicativo e exibe a 
            mensagem de erro para o desenvolvedor.
        */
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

