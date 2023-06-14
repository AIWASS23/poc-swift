import UIKit
import WatchConnectivity

// Define uma interface para encapsular as APIs do Watch Connectivity e conecta a interface do usuário.

protocol SessionCommands {
    func updateAppContext(_ context: [String: Any])
    func sendMessage(_ message: [String: Any])
    func sendMessageData(_ messageData: Data)
    func transferUserInfo(_ userInfo: [String: Any])
    func transferFile(_ file: URL, metadata: [String: Any])
    func transferCurrentComplicationUserInfo(_ userInfo: [String: Any])
}

/* 
    Implemente os comandos. Cada comando lida com a comunicação e notifica os clientes
    quando o status da WCSession muda ou os dados fluem.
*/
extension SessionCommands {
    
    /*
        Atualiza o contexto do aplicativo se a sessão estiver ativada e atualize a 
        interface do usuário com o status do comando.
    */
    func updateAppContext(_ context: [String: Any]) {
        var commandStatus = CommandStatus(command: .updateAppContext, phrase: .updated)
        commandStatus.timedColor = TimedColor(context)
        
        guard WCSession.default.activationState == .activated else {
            return handleSessionUnactivated(with: commandStatus)
        }
        do {
            try WCSession.default.updateApplicationContext(context)
        } catch {
            commandStatus.phrase = .failed
            commandStatus.errorMessage = error.localizedDescription
        }
        postNotificationOnMainQueueAsync(name: .dataDidFlow, object: commandStatus)
    }

    /* 
        Envia uma mensagem se a sessão estiver ativada e atualize a UI com o status do comando.
    */
    func sendMessage(_ message: [String: Any]) {
        var commandStatus = CommandStatus(command: .sendMessage, phrase: .sent)
        commandStatus.timedColor = TimedColor(message)

        guard WCSession.default.activationState == .activated else {
            return handleSessionUnactivated(with: commandStatus)
        }
        
        // Um bloco de manipulador de resposta é executado de forma assíncrona em um thread em segundo plano e deve retornar rapidamente.

        WCSession.default.sendMessage(message, replyHandler: { replyMessage in
            commandStatus.phrase = .replied
            commandStatus.timedColor = TimedColor(replyMessage)
            self.postNotificationOnMainQueueAsync(name: .dataDidFlow, object: commandStatus)

        }, errorHandler: { error in
            commandStatus.phrase = .failed
            commandStatus.errorMessage = error.localizedDescription
            self.postNotificationOnMainQueueAsync(name: .dataDidFlow, object: commandStatus)
        })
        postNotificationOnMainQueueAsync(name: .dataDidFlow, object: commandStatus)
    }
    
    // Envia uma parte dos dados da mensagem se a sessão estiver ativada e atualize a UI com o status do comando.

    func sendMessageData(_ messageData: Data) {
        var commandStatus = CommandStatus(command: .sendMessageData, phrase: .sent)
        commandStatus.timedColor = TimedColor(messageData)
        
        guard WCSession.default.activationState == .activated else {
            return handleSessionUnactivated(with: commandStatus)
        }
        
        WCSession.default.sendMessageData(messageData, replyHandler: { replyData in
            commandStatus.phrase = .replied
            commandStatus.timedColor = TimedColor(replyData)
            self.postNotificationOnMainQueueAsync(name: .dataDidFlow, object: commandStatus)

        }, errorHandler: { error in
            commandStatus.phrase = .failed
            commandStatus.errorMessage = error.localizedDescription
            self.postNotificationOnMainQueueAsync(name: .dataDidFlow, object: commandStatus)
        })
        postNotificationOnMainQueueAsync(name: .dataDidFlow, object: commandStatus)
    }
    
    /* 
        Transfere uma parte das informações do usuário se a sessão estiver ativada e atualize a UI com o status do comando.
        Retorna um objeto WCSessionUserInfoTransfer para monitorar o progresso ou cancelar a operação.
    */
    func transferUserInfo(_ userInfo: [String: Any]) {
        var commandStatus = CommandStatus(command: .transferUserInfo, phrase: .transferring)
        commandStatus.timedColor = TimedColor(userInfo)

        guard WCSession.default.activationState == .activated else {
            return handleSessionUnactivated(with: commandStatus)
        }

        commandStatus.userInfoTranser = WCSession.default.transferUserInfo(userInfo)
        postNotificationOnMainQueueAsync(name: .dataDidFlow, object: commandStatus)
    }
    
    /* 
        Transfere uma parte das informações do usuário se a sessão estiver ativada e atualize a UI com o status do comando.
        Retorna um objeto WCSessionFileTransfer para monitorar o progresso ou cancelar a operação.
    */
    func transferFile(_ file: URL, metadata: [String: Any]) {
        var commandStatus = CommandStatus(command: .transferFile, phrase: .transferring)
        commandStatus.timedColor = TimedColor(metadata)

        guard WCSession.default.activationState == .activated else {
            return handleSessionUnactivated(with: commandStatus)
        }
        commandStatus.fileTransfer = WCSession.default.transferFile(file, metadata: metadata)
        postNotificationOnMainQueueAsync(name: .dataDidFlow, object: commandStatus)
    }
    
    /* 
        Transfere uma parte das informações do usuário para complicações atuais se a sessão for ativada,
        e atualize a UI com o status do comando. Retorna um objeto WCSessionUserInfoTransfer para 
        monitorar o progresso ou cancelar a operação.
    */
    func transferCurrentComplicationUserInfo(_ userInfo: [String: Any]) {
        var commandStatus = CommandStatus(command: .transferCurrentComplicationUserInfo, phrase: .failed)
        commandStatus.timedColor = TimedColor(userInfo)

        guard WCSession.default.activationState == .activated else {
            return handleSessionUnactivated(with: commandStatus)
        }
        
        commandStatus.errorMessage = "Not supported on watchOS!"
        
        #if os(iOS)
        if WCSession.default.isComplicationEnabled {
            let userInfoTranser = WCSession.default.transferCurrentComplicationUserInfo(userInfo)
            commandStatus.phrase = .transferring
            commandStatus.errorMessage = nil
            commandStatus.userInfoTranser = userInfoTranser
            
        } else {
            commandStatus.errorMessage = "\nComplication is not enabled!"
        }
        #endif
        
        postNotificationOnMainQueueAsync(name: .dataDidFlow, object: commandStatus)
    }
    
    // Publica uma notificação da fila principal de forma assíncrona.
    
    private func postNotificationOnMainQueueAsync(name: NSNotification.Name, object: CommandStatus) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: name, object: object)
        }
    }

    // Lidar com erro de sessão desativada. Os comandos WCSession requerem uma sessão ativada.
    
    private func handleSessionUnactivated(with commandStatus: CommandStatus) {
        var mutableStatus = commandStatus
        mutableStatus.phrase = .failed
        mutableStatus.errorMessage = "WCSession is not activated yet!"
        postNotificationOnMainQueueAsync(name: .dataDidFlow, object: commandStatus)
    }
}