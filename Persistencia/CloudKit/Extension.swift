import CoreData
import CloudKit

extension CoreDataStack {
    func save() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("ViewContext save error: \(error)")
            }
        }
    }

    func delete(_ destination: Destination) {
        context.perform {
            self.context.delete(destination)
            self.save()
        }
    }
}

/*
    A extensão para a classe CoreDataStack com as funções save() e delete(_:).

    A função save() verifica se há alterações pendentes no contexto do objeto gerenciado 
    NSManagedObjectContext, e, caso haja, salva essas alterações no armazenamento persistente 
    usando o método save().

    A função delete(_:) exclui um objeto gerenciado Destination do contexto do objeto gerenciado 
    NSManagedObjectContext. A exclusão é realizada dentro de um bloco perform para garantir que a 
    operação ocorra na thread do contexto. Depois que o objeto é excluído, a função chama a função 
    save() para salvar as alterações no armazenamento persistente.
*/

// MARK: Share a record from Core Data
extension CoreDataStack {
    func isShared(object: NSManagedObject) -> Bool {
        isShared(objectID: object.objectID)
    }

    func canEdit(object: NSManagedObject) -> Bool {
        return persistentContainer.canUpdateRecord(forManagedObjectWith: object.objectID)
    }

    func canDelete(object: NSManagedObject) -> Bool {
        return persistentContainer.canDeleteRecord(forManagedObjectWith: object.objectID)
    }

    func isOwner(object: NSManagedObject) -> Bool {
        guard isShared(object: object) else { return false }
        guard let share = try? persistentContainer.fetchShares(matching: [object.objectID])[object.objectID] else {
            print("Get ckshare error")
            return false
        }
        if let currentUser = share.currentUserParticipant, currentUser == share.owner {
            return true
        }
        return false
    }

    func getShare(_ destination: Destination) -> CKShare? {
        guard isShared(object: destination) else { return nil }
        guard let shareDictionary = try? persistentContainer.fetchShares(matching: [destination.objectID]),
        let share = shareDictionary[destination.objectID] else {
            print("Unable to get CKShare")
            return nil
        }
        share[CKShare.SystemFieldKey.title] = destination.caption
        return share
    }

    private func isShared(objectID: NSManagedObjectID) -> Bool {
        var isShared = false
        if let persistentStore = objectID.persistentStore {
            if persistentStore == sharedPersistentStore {
                isShared = true
            } 
            else {
                let container = persistentContainer
                do {
                    let shares = try container.fetchShares(matching: [objectID])
                    if shares.first != nil {
                        isShared = true
                    }
                } catch {
                    print("Failed to fetch share for \(objectID): \(error)")
                }
            }
        }
        return isShared
    }
}

/*

    A extensão da classe CoreDataStack e contém várias funções para trabalhar com objetos gerenciados 
    do Core Data e compartilhamento de registros do CloudKit.

    A função isShared verifica se um objeto gerenciado está sendo compartilhado.

    A função canEdit verifica se um objeto gerenciado pode ser atualizado no CloudKit.

    A função canDelete verifica se um objeto gerenciado pode ser excluído do CloudKit.

    A função isOwner verifica se o usuário atual é o proprietário de um objeto compartilhado.

    A função getShare recupera o registro de compartilhamento do CloudKit para um objeto gerenciado específico e retorna um CKShare opcional. Se o objeto não estiver compartilhado, nil é retornado.

    A função isShared é uma função auxiliar que verifica se um objeto gerenciado está sendo 
    compartilhado em um armazenamento persistente específico. Ele verifica se o objeto está no 
    armazenamento compartilhado ou se ele tem um registro de compartilhamento associado a ele.

*/
