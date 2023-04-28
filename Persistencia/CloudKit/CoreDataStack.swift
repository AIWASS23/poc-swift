import CoreData
import CloudKit

final class CoreDataStack: ObservableObject {
    static let shared = CoreDataStack()

    var ckContainer: CKContainer {
        let storeDescription = persistentContainer.persistentStoreDescriptions.first
        guard let identifier = storeDescription?.cloudKitContainerOptions?.containerIdentifier else {
        fatalError("Unable to get container identifier")
        }
        return CKContainer(identifier: identifier)
    }

    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    var privatePersistentStore: NSPersistentStore {
        guard let privateStore = _privatePersistentStore else {
        fatalError("Private store is not set")
        }
        return privateStore
    }

    var sharedPersistentStore: NSPersistentStore {
        guard let sharedStore = _sharedPersistentStore else {
        fatalError("Shared store is not set")
        }
        return sharedStore
    }

    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "MyTravelJournal")

        guard let privateStoreDescription = container.persistentStoreDescriptions.first else {
        fatalError("Unable to get persistentStoreDescription")
        }
        let storesURL = privateStoreDescription.url?.deletingLastPathComponent()
        privateStoreDescription.url = storesURL?.appendingPathComponent("private.sqlite")
        let sharedStoreURL = storesURL?.appendingPathComponent("shared.sqlite")
        guard let sharedStoreDescription = privateStoreDescription.copy() as? NSPersistentStoreDescription else {
        fatalError("Copying the private store description returned an unexpected value.")
        }
        sharedStoreDescription.url = sharedStoreURL

        guard let containerIdentifier = privateStoreDescription.cloudKitContainerOptions?.containerIdentifier else {
        fatalError("Unable to get containerIdentifier")
        }
        let sharedStoreOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: containerIdentifier)
        sharedStoreOptions.databaseScope = .shared
        sharedStoreDescription.cloudKitContainerOptions = sharedStoreOptions
        container.persistentStoreDescriptions.append(sharedStoreDescription)

        container.loadPersistentStores { loadedStoreDescription, error in
        if let error = error as NSError? {
            fatalError("Failed to load persistent stores: \(error)")
        } else if let cloudKitContainerOptions = loadedStoreDescription.cloudKitContainerOptions {
            guard let loadedStoreDescritionURL = loadedStoreDescription.url else {
            return
            }

            if cloudKitContainerOptions.databaseScope == .private {
            let privateStore = container.persistentStoreCoordinator.persistentStore(for: loadedStoreDescritionURL)
            self._privatePersistentStore = privateStore
            } else if cloudKitContainerOptions.databaseScope == .shared {
            let sharedStore = container.persistentStoreCoordinator.persistentStore(for: loadedStoreDescritionURL)
            self._sharedPersistentStore = sharedStore
            }
        }
        }

        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
        do {
        try container.viewContext.setQueryGenerationFrom(.current)
        } catch {
        fatalError("Failed to pin viewContext to the current generation: \(error)")
        }

        return container
    }()

    private var _privatePersistentStore: NSPersistentStore?
    private var _sharedPersistentStore: NSPersistentStore?
    private init() {}
}

/*
    A classe CoreDataStack configura e gerencia um NSPersistentCloudKitContainer, que é uma classe do 
    CoreData que integra o CloudKit, permitindo que os dados sejam armazenados em nuvem.

    A classe tem um método estático shared que retorna uma instância compartilhada da classe 
    CoreDataStack, permitindo que a mesma instância seja usada em toda a aplicação.

    A classe tem uma propriedade persistentContainer que é uma instância do 
    NSPersistentCloudKitContainer. O método loadPersistentStores é usado para carregar a configuração 
    do container e inicializar os persistent stores, que armazenam os dados do aplicativo. 
    A instância do container também tem uma configuração do CloudKit, permitindo o uso do serviço de 
    armazenamento em nuvem.

    A classe tem outras propriedades que retornam o contexto de visualização do container, assim como 
    as instâncias dos persistent stores privados e compartilhados. Além disso, há um método que 
    retorna uma instância do CKContainer, que é usado para configurar e compartilhar dados com o 
    serviço CloudKit.
*/