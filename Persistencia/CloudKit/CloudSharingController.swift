import CloudKit
import SwiftUI

struct CloudSharingView: UIViewControllerRepresentable {
    let share: CKShare
    let container: CKContainer
    let destination: Destination

    func makeCoordinator() -> CloudSharingCoordinator {
        CloudSharingCoordinator(destination: destination)
    }

    func makeUIViewController(context: Context) -> UICloudSharingController {
        share[CKShare.SystemFieldKey.title] = destination.caption
        let controller = UICloudSharingController(share: share, container: container)
        controller.modalPresentationStyle = .formSheet
        controller.delegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: UICloudSharingController, context: Context) {
    }
    }

    final class CloudSharingCoordinator: NSObject, UICloudSharingControllerDelegate {
    let stack = CoreDataStack.shared
    let destination: Destination
    init(destination: Destination) {
        self.destination = destination
    }

    func itemTitle(for csc: UICloudSharingController) -> String? {
        destination.caption
    }

    func cloudSharingController(_ csc: UICloudSharingController, failedToSaveShareWithError error: Error) {
        print("Failed to save share: \(error)")
    }

    func cloudSharingControllerDidSaveShare(_ csc: UICloudSharingController) {
        print("Saved the share")
    }

    func cloudSharingControllerDidStopSharing(_ csc: UICloudSharingController) {
        if !stack.isOwner(object: destination) {
        stack.delete(destination)
        }
    }
}

/*
    O CloudSharingView é uma classe CloudSharingCoordinator em conjunto com a utilização dos 
    frameworks CloudKit e SwiftUI. A struct CloudSharingView é uma representação de uma tela de 
    compartilhamento de nuvem (cloud sharing) usando o UICloudSharingController fornecido pela 
    CloudKit. A class CloudSharingCoordinator é um objeto que coordena as ações do 
    UICloudSharingController.

    O CloudSharingView é um componente de interface do usuário que cria e gerencia um 
    UICloudSharingController, que é responsável por apresentar a tela de compartilhamento de nuvem 
    para o usuário. A struct CloudSharingView é inicializada com três propriedades: share, container, 
    e destination. share representa o objeto CKShare a ser compartilhado, container representa o 
    CKContainer usado para compartilhar o share e destination é o objeto de destino que está sendo 
    compartilhado.

    makeUIViewController é um método requerido para a conformidade com UIViewControllerRepresentable, 
    que cria e retorna um UICloudSharingController inicializado com share e container. Além disso, 
    makeUIViewController define o estilo de apresentação modal como .formSheet e define o delegate 
    para o context.coordinator. updateUIViewController é um método opcional que não faz nada neste caso.

    A classe CloudSharingCoordinator é uma classe que lida com os eventos do UICloudSharingController. 
    Ela é inicializada com um objeto destination que representa o objeto de destino que está sendo 
    compartilhado. itemTitle(for:) é um método opcional do UICloudSharingControllerDelegate que 
    retorna o título do objeto sendo compartilhado. 
    cloudSharingController(_:failedToSaveShareWithError:) é um método do 
    UICloudSharingControllerDelegate que é chamado se houver um erro ao salvar o compartilhamento. 
    cloudSharingControllerDidSaveShare(_:) é um método do UICloudSharingControllerDelegate que é 
    chamado quando o compartilhamento é salvo com sucesso. 
    cloudSharingControllerDidStopSharing(_:) é um método do UICloudSharingControllerDelegate que é 
    chamado quando o compartilhamento é interrompido. Neste método, se o objeto destination não é de 
    propriedade (ownership) do usuário atual, ele é excluído do CoreDataStack.
*/