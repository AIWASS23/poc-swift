import WatchKit
import WatchConnectivity

class ExtensionDelegate: NSObject, WKExtensionDelegate {

    private lazy var sessionDelegator: SessionDelegator = {
        return SessionDelegator()
    }()

    //Segura os observadores KVO (Key-Value Observing) para continuar observando a mudança no tempo de vida da extensão. 

    private var activationStateObservation: NSKeyValueObservation?
    private var hasContentPendingObservation: NSKeyValueObservation?

    // Uma matriz para manter as tarefas em segundo plano.
    
    private var wcBackgroundTasks = [WKWatchConnectivityRefreshBackgroundTask]()
    
    override init() {
        super.init()
        assert(WCSession.isSupported(), "This sample requires a platform supporting Watch Connectivity!")
                
        /* 
            Os aplicativos devem concluir WKWatchConnectivityRefreshBackgroundTask. 
            Caso contrário, as tarefas continuam consumindo o tempo de execução em segundo plano e, 
            eventualmente, causar uma falha. O tempo para concluir as tarefas é quando a WCSession atual 
            muda para um estado diferente de .activated ou hasContentPending vira falso (completeBackgroundTasks), 
            então use KVO para observar as mudanças das duas propriedades.
        */
        activationStateObservation = WCSession.default.observe(\.activationState) { _, _ in
            DispatchQueue.main.async {
                self.completeBackgroundTasks()
            }
        }
        hasContentPendingObservation = WCSession.default.observe(\.hasContentPending) { _, _ in
            DispatchQueue.main.async {
                self.completeBackgroundTasks()
            }
        }

        /* 
            Ative a sessão de forma assíncrona o mais cedo possível. Quando o sistema precisa iniciar o 
            aplicativo para executar uma tarefa em segundo plano, isso economiza algum orçamento de tempo 
            de execução em segundo plano.        
        */

        WCSession.default.delegate = sessionDelegator
        WCSession.default.activate()
    }
    
    // Conclue as tarefas em segundo plano e agenda uma atualização instantânea.
    
    func completeBackgroundTasks() {
        guard !wcBackgroundTasks.isEmpty else { return }

        guard WCSession.default.activationState == .activated,
            WCSession.default.hasContentPending == false else { return }
        
        wcBackgroundTasks.forEach { $0.setTaskCompletedWithSnapshot(false) }
        
        // Use o Logger para registrar tarefas para fins de depuração.
        
        Logger.shared.append(line: "\(#function):\(wcBackgroundTasks) was completed!")

        // Agenda uma atualização instantânea se a interface do usuário for atualizada por tarefas em segundo plano.
        
        let date = Date(timeIntervalSinceNow: 1)
        WKExtension.shared().scheduleSnapshotRefresh(withPreferredDate: date, userInfo: nil) { error in
            
            if let error = error {
                print("scheduleSnapshotRefresh error: \(error)!")
            }
        }
        wcBackgroundTasks.removeAll()
    }
    
    /* 
        O app deve concluir WKWatchConnectivityRefreshBackgroundTask após o recebimento dos dados 
        pendentes. Neste exemplo retém as tarefas primeiro e as conclui nos seguintes casos:
         1. hasContentPending muda para falso, significando que não há dados pendentes aguardando 
         processamento. Dados pendentes significa: Os dados que o dispositivo recebe antes de a 
         WCSession ser ativada. Mais dados podem chegar, mas não ficam pendentes quando a sessão é ativada.
         2. O fim do método handle. Isso acontece quando hasContentPending muda para false antes que o 
         aplicativo retenha as tarefas.
    */
    
    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        for task in backgroundTasks {
            if let wcTask = task as? WKWatchConnectivityRefreshBackgroundTask {
                wcBackgroundTasks.append(wcTask)
                Logger.shared.append(line: "\(#function):\(wcTask.description) was appended!")
            } else {
                task.setTaskCompletedWithSnapshot(false)
                Logger.shared.append(line: "\(#function):\(task.description) was completed!")
            }
        }
        completeBackgroundTasks()
    }
}