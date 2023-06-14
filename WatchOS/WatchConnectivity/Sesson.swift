import Foundation
import WatchConnectivity

#if os(watchOS)
import ClockKit
#endif

/* 
    As notificações personalizadas acontecem quando a ativação do Watch Connectivity 
    ou o status de acessibilidade são alterados, ou ao receber ou enviar dados. 
    Os clientes observam essas notificações para atualizar a UI.
*/
extension Notification.Name {
    static let dataDidFlow = Notification.Name("DataDidFlow")
    static let activationDidComplete = Notification.Name("ActivationDidComplete")
    static let reachabilityDidChange = Notification.Name("ReachabilityDidChange")
}

/* 
    Implementa métodos WCSessionDelegate para receber dados do Watch Connectivity e notificar os clientes.
    Lida com mudanças de status WCSession.
*/
class SessionDelegator: NSObject, WCSessionDelegate {
    
    // Monitora mudanças no estado de ativação do WCSession.
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        postNotificationOnMainQueueAsync(name: .activationDidComplete)
    }
    
    // Monitor as alterações de estado de acessibilidade do WCSession.
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        postNotificationOnMainQueueAsync(name: .reachabilityDidChange)
    }
    
    // Recebe um contexto de aplicativo
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String: Any]) {
        var commandStatus = CommandStatus(command: .updateAppContext, phrase: .received)
        commandStatus.timedColor = TimedColor(applicationContext)
        postNotificationOnMainQueueAsync(name: .dataDidFlow, object: commandStatus)
    }
    
    // Recebe uma mensagem e o peer não precisa de uma resposta.
    
    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        var commandStatus = CommandStatus(command: .sendMessage, phrase: .received)
        commandStatus.timedColor = TimedColor(message)
        postNotificationOnMainQueueAsync(name: .dataDidFlow, object: commandStatus)
    }
    
    // Recebe uma mensagem e o peer precisa de uma resposta.
    
    func session(_ session: WCSession, didReceiveMessage message: [String: Any], replyHandler: @escaping ([String: Any]) -> Void) {
        self.session(session, didReceiveMessage: message)
        replyHandler(message) // Echo back the time stamp.
    }
    
    // Recebe uma parte dos dados da mensagem e o peer não precisa de uma resposta.
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
        var commandStatus = CommandStatus(command: .sendMessageData, phrase: .received)
        commandStatus.timedColor = TimedColor(messageData)
        postNotificationOnMainQueueAsync(name: .dataDidFlow, object: commandStatus)
    }
    
    // Recebe uma parte dos dados da mensagem e o peer precisa de uma resposta.
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data, replyHandler: @escaping (Data) -> Void) {
        self.session(session, didReceiveMessageData: messageData)
        replyHandler(messageData) // Echo back the time stamp.
    }
    
    // Recebe um pedaço de userInfo.
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String: Any] = [:]) {
        var commandStatus = CommandStatus(command: .transferUserInfo, phrase: .received)
        commandStatus.timedColor = TimedColor(userInfo)
        
        if let isComplicationInfo = userInfo[PayloadKey.isCurrentComplicationInfo] as? Bool,
            isComplicationInfo == true {
            
            commandStatus.command = .transferCurrentComplicationUserInfo
            
            #if os(watchOS)
            let server = CLKComplicationServer.sharedInstance()
            if let complications = server.activeComplications {
                for complication in complications {
                    /* 
                        Use esse método com moderação.
                        Em vez disso, use extendTimeline(for:) quando a linha do tempo ainda for válida.
                    */
                    server.reloadTimeline(for: complication)
                }
            }

            #endif
        }
        postNotificationOnMainQueueAsync(name: .dataDidFlow, object: commandStatus)
    }
    
    // Terminou de enviar um pedaço de userInfo.
    
    func session(_ session: WCSession, didFinish userInfoTransfer: WCSessionUserInfoTransfer, error: Error?) {
        var commandStatus = CommandStatus(command: .transferUserInfo, phrase: .finished)
        commandStatus.timedColor = TimedColor(userInfoTransfer.userInfo)
        
        #if os(iOS)
        if userInfoTransfer.isCurrentComplicationInfo {
            commandStatus.command = .transferCurrentComplicationUserInfo
        }
        #endif

        if let error = error {
            commandStatus.errorMessage = error.localizedDescription
        }
        postNotificationOnMainQueueAsync(name: .dataDidFlow, object: commandStatus)
    }
    
    // Recebe um arquivo.
    
    func session(_ session: WCSession, didReceive file: WCSessionFile) {
        var commandStatus = CommandStatus(command: .transferFile, phrase: .received)
        commandStatus.file = file
        commandStatus.timedColor = TimedColor(file.metadata!)
        
        /* 
            O sistema remove WCSessionFile.fileURL assim que esse método retorna,
            então envie para a fila principal de forma síncrona em vez de chamar
            postNotificationOnMainQueue(name: .dataDidFlow, userInfo: userInfo).
        */
        DispatchQueue.main.sync {
            NotificationCenter.default.post(name: .dataDidFlow, object: commandStatus)
        }
    }
    
    // Terminou uma transferência de arquivo.
    
    func session(_ session: WCSession, didFinish fileTransfer: WCSessionFileTransfer, error: Error?) {
        var commandStatus = CommandStatus(command: .transferFile, phrase: .finished)

        if let error = error {
            commandStatus.errorMessage = error.localizedDescription
            postNotificationOnMainQueueAsync(name: .dataDidFlow, object: commandStatus)
            return
        }
        commandStatus.fileTransfer = fileTransfer
        commandStatus.timedColor = TimedColor(fileTransfer.file.metadata!)

        #if os(watchOS)
        Logger.shared.clearLogs()
        #endif
        postNotificationOnMainQueueAsync(name: .dataDidFlow, object: commandStatus)
    }
    
    // Métodos WCSessionDelegate somente para iOS.
    
    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("\(#function): activationState = \(session.activationState.rawValue)")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        // Ativa a nova sessão depois de mudar para um novo relógio.
        session.activate()
    }
    
    func sessionWatchStateDidChange(_ session: WCSession) {
        print("\(#function): activationState = \(session.activationState.rawValue)")
    }
    #endif
    
    // Publica uma notificação no thread principal de forma assíncrona.
    
    private func postNotificationOnMainQueueAsync(name: NSNotification.Name, object: CommandStatus? = nil) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: name, object: object)
        }
    }
}