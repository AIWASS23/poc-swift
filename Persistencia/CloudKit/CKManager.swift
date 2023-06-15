import CloudKit

protocol CKCodable {
    init?(record: CKRecord)
    var record: CKRecord? { get }

    /*
        Protocolo CKCodable:
        É um protocolo definido para objetos que podem ser codificados e decodificados para o formato CKRecord, 
        que é usado pelo CloudKit. Ele define um inicializador init?(record: CKRecord) para criar um objeto a 
        partir de um CKRecord e uma propriedade record que retorna o CKRecord correspondente ao objeto. Esse 
        protocolo é usado para permitir a conversão entre os objetos do aplicativo e os registros do CloudKit.
    */
}

class CKManager {
    
    enum iCloudKitError: LocalizedError {
        case iCloudAccountNotFound
        case iCloudAccountNotDetermined
        case iCloudAccountRestricted
        case iCloudAccountUnknown
        case iCloudAccountNoID
        case iCloudApplicationPermissionNotGranted
        case iCloudDatabaseError

        /*
            Representa os possíveis erros relacionados ao CloudKit que podem ocorrer durante a execução das operações.
        */
    }
}

//MARK: User functions

extension CKManager {
    
    static func getiCloudStatus(completion: @escaping (Result<Bool, Error>) -> ()) {
        CKContainer.default().accountStatus { accountStatus, error in
            switch accountStatus {
            case .available:
                completion(.success(true))
            case .noAccount:
                completion(.failure(iCloudKitError.iCloudAccountNotFound))
            case .couldNotDetermine:
                completion(.failure(iCloudKitError.iCloudAccountNotDetermined))
            case .restricted:
                completion(.failure(iCloudKitError.iCloudAccountRestricted))
            default:
                completion(.failure(iCloudKitError.iCloudAccountUnknown))
            }
        }

        /*
            A função getiCloudStatus permite verificar o status da conta iCloud e retornar o resultado através da 
            closure de completion, permitindo que o aplicativo tome as medidas apropriadas com base no estado da 
            conta iCloud.
        */
    }
    
    static func requestPermission(completion: @escaping (Result<Bool, Error>) -> ()) {
        let iCloud = CKContainer.default()
        iCloud.requestApplicationPermission(.userDiscoverability) { returnedStatus, error in
            if returnedStatus == .granted {
                completion(.success(true))
            } else {
                completion(.failure(iCloudKitError.iCloudApplicationPermissionNotGranted))
            }
        }

        /*
            A função requestPermission é responsável por solicitar permissão ao usuário para acessar as informações 
            de descoberta do usuário no iCloud. Essa permissão é necessária para identificar o usuário no serviço 
            iCloud. A função recebe uma closure completion como parâmetro, que será chamada quando a solicitação 
            de permissão for concluída. Dentro da função, é utilizado o objeto CKContainer.default() para acessar 
            o container padrão do iCloud. Em seguida, é chamado o método requestApplicationPermission do container, 
            passando o parâmetro .userDiscoverability que indica a permissão de descoberta do usuário. O método 
            requestApplicationPermission recebe uma closure que contém dois parâmetros: returnedStatus, 
            que representa o status da permissão solicitada, e error, que representa qualquer erro que possa ter 
            ocorrido durante a solicitação. Dentro da closure, é verificado se o returnedStatus é igual a .granted, 
            o que indica que a permissão foi concedida pelo usuário. Se for o caso, a closure de completion é 
            chamada com .success(true), indicando que a permissão foi concedida com sucesso. Se o returnedStatus 
            não for .granted, significa que a permissão não foi concedida pelo usuário. Nesse caso, a closure de 
            completion é chamada com .failure(iCloudKitError.iCloudApplicationPermissionNotGranted), indicando que 
            a permissão não foi concedida.
        */
    }
    
    static func getiCloudUserID(completion: @escaping(Result<CKRecord.ID, Error>) -> ()) {
        let iCloud = CKContainer.default()
        iCloud.fetchUserRecordID { userRecordID, error in
            guard let recordID = userRecordID else {
                completion(.failure(iCloudKitError.iCloudAccountNoID))
                return
            }
            completion(.success(recordID))
        }

        /*
            A função getiCloudUserID é responsável por obter o identificador de registro (record ID) do usuário 
            atualmente logado no iCloud. O identificador de registro é um valor exclusivo que identifica de forma 
            única um registro no banco de dados do iCloud. A função recebe uma closure completion como parâmetro, 
            que será chamada quando a obtenção do identificador de registro for concluída. Dentro da função, é 
            utilizado o objeto CKContainer.default() para acessar o container padrão do iCloud. Em seguida, é 
            chamado o método fetchUserRecordID do container para obter o identificador de registro do usuário. 
            O método fetchUserRecordID recebe uma closure que contém dois parâmetros: userRecordID, que representa 
            o identificador de registro do usuário, e error, que representa qualquer erro que possa ter ocorrido 
            durante a obtenção do identificador de registro. Dentro da closure, é verificado se o userRecordID é 
            diferente de nil, o que indica que o identificador de registro foi obtido com sucesso. Nesse caso, a 
            closure de completion é chamada com .success(recordID), onde recordID é o identificador de registro 
            obtido. Se o userRecordID for nil, significa que não foi possível obter o identificador de registro do 
            usuário. Nesse caso, a closure de completion é chamada com .failure(iCloudKitError.iCloudAccountNoID), 
            indicando que não há um identificador de registro disponível para a conta iCloud atual.
        */
    }
    
    static func getUserName(forID userID: CKRecord.ID, completion: @escaping(Result<String, Error>) -> ()) {
        let iCloud = CKContainer.default()
        var givenName: String = ""
        var familyName: String = ""
        iCloud.discoverUserIdentity(withUserRecordID: userID) { userIndentity, error in
            if let name = userIndentity?.nameComponents?.givenName {
                givenName = name
            }
            if let surname = userIndentity?.nameComponents?.familyName {
                familyName = surname
            }
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(givenName + " " + familyName))
            }
        }

        /*
            A função getUserName é responsável por obter o nome completo do usuário associado a um determinado 
            identificador de registro (userID) no iCloud. Ela utiliza o serviço de descoberta de identidade do 
            iCloud para buscar as informações do usuário. A função recebe dois parâmetros: userID, que representa 
            o identificador de registro do usuário para o qual se deseja obter o nome, e completion, uma closure 
            que será chamada quando a obtenção do nome for concluída. Dentro da função, é utilizado o objeto 
            CKContainer.default() para acessar o container padrão do iCloud. Em seguida, é chamado o método 
            discoverUserIdentity do container, passando o userID como parâmetro para buscar as informações de 
            identidade do usuário correspondente ao identificador de registro. O método discoverUserIdentity 
            recebe uma closure que contém dois parâmetros: userIdentity, que representa as informações de 
            identidade do usuário, e error, que representa qualquer erro que possa ter ocorrido durante a busca 
            das informações. Dentro da closure, é verificado se o userIdentity não é nulo (nil). Em seguida, são 
            extraídos o nome próprio (givenName) e o sobrenome (familyName) do userIdentity, caso estejam 
            disponíveis. Esses valores são armazenados nas variáveis givenName e familyName, respectivamente. Se 
            ocorrer algum erro durante a busca das informações, a closure de completion é chamada 
            com .failure(error), indicando que houve um erro ao obter o nome do usuário. Caso não ocorra nenhum 
            erro, a closure de completion é chamada com .success(givenName + " " + familyName), concatenando o 
            nome próprio e o sobrenome do usuário e retornando o nome completo como uma string.
        */
    }
}

//MARK: CRUD functions

extension CKManager {
    
    // CREATE
    
    static func add<T: CKCodable>(item: T, completion: @escaping (Result<CKRecord?, Error>) -> ()) {
        guard let record = item.record else {
            completion(.failure(iCloudKitError.iCloudDatabaseError))
            return
        }
        
        save(record: record, completion: completion)

        /*
            A função add é responsável por adicionar um item ao banco de dados do iCloud. Ela recebe um item que 
            deve ser compatível com o protocolo CKCodable, que define os métodos necessários para mapear o item 
            para um CKRecord. Se o item possui um CKRecord válido, ele é salvo no banco de dados do iCloud. 
            Caso contrário, é retornado um erro indicando que houve um problema no banco de dados do iCloud. 
            O resultado da operação é retornado através da closure de completion.
        */
    }
    
    static func addWithReference<T: CKCodable, C: CKCodable>(
        fromItem childItem: T,
        toItem parentItem: C,
        withReferenceFieldName referenceFieldName: String,
        withReferenceAction refAction: CKRecord.ReferenceAction,
        completion: @escaping (Result<CKRecord?, Error>) -> ()) {

            // Check if records exist
            guard let childRecord = childItem.record else {
                completion(.failure(iCloudKitError.iCloudDatabaseError))
                return
            }
            guard let parentRecord = parentItem.record else {
                completion(.failure(iCloudKitError.iCloudDatabaseError))
                return
            }
            
            // Adding reference
            childRecord[referenceFieldName] = CKRecord.Reference(record: parentRecord, action: refAction)
            
            // Saving item
            save(record: childRecord, completion: completion)

        /*
            A função addWithReference é responsável por adicionar um item ao banco de dados do iCloud com uma 
            referência a outro item existente. Ela recebe dois itens, um item filho (childItem) e um item pai 
            (parentItem), ambos compatíveis com o protocolo CKCodable. Além disso, são fornecidos o nome do campo 
            de referência (referenceFieldName) e a ação de referência (refAction). Primeiro, a função verifica se 
            os registros (CKRecord) correspondentes aos itens filho e pai existem. Se algum deles não existir, a 
            função retorna um erro indicando um problema no banco de dados do iCloud. Em seguida, a função 
            adiciona a referência do item pai ao campo de referência especificado no registro do item filho. 
            Por fim, a função chama o método save para salvar o registro do item filho, juntamente com a referência 
            ao item pai, no banco de dados do iCloud. O resultado da operação é retornado através da closure de 
            completion.
        */
    }
    
    // READ
    
    static func fetch<T:CKCodable>(
        predicate: NSPredicate,
        recordType: CKRecord.RecordType,
        sortDescriptions: [NSSortDescriptor]? = nil,
        resultsLimit: Int? = nil,
        completion: @escaping(_ items: [T]) -> ()) {
        
        // Create operation
        let queryOperation = createOperation(
            predicate: predicate,
            recordType: recordType,
            sortDescriptions: sortDescriptions,
            resultsLimit: resultsLimit
        )
        
        // Get items
        var returnedItems: [T] = []
        addRecordMatchedBlock(operation: queryOperation) { item in
            returnedItems.append(item)
        }
        
        // Result
        addQuerryResultBlock(operation: queryOperation) { finished in
            if finished {
                completion(returnedItems)
            }
        }
        
        addOperation(operation: queryOperation)

        /*
            A função fetch é responsável por buscar itens do banco de dados do iCloud que correspondam a um 
            determinado predicado. Ela recebe o predicado de busca, o tipo de registro desejado, as descrições de 
            ordenação opcionais, o limite de resultados opcional e uma closure de conclusão para retornar os itens 
            encontrados. Primeiro, a função cria uma operação de consulta (queryOperation) utilizando os 
            parâmetros fornecidos. Em seguida, ela define uma variável returnedItems para armazenar os itens 
            retornados. A função adiciona uma closure (addRecordMatchedBlock) que é executada para cada registro 
            correspondente encontrado na operação de consulta. Dentro dessa closure, o item correspondente é 
            mapeado e adicionado à lista returnedItems. Depois disso, a função adiciona outra closure 
            (addQueryResultBlock) que é chamada quando a operação de consulta é concluída. Essa closure verifica 
            se a consulta foi finalizada e, se sim, chama a closure de conclusão fornecida, passando a 
            lista returnedItems. Por fim, a função chama a função auxiliar addOperation para adicionar a operação 
            de consulta ao banco de dados do iCloud.
        */
    }
    
    static func fetchReferences<T: CKCodable, C: CKCodable>(
        forItem owner: T,
        andField searchField: String,
        recordType: CKRecord.RecordType,
        sortDescriptions: [NSSortDescriptor]? = nil,
        resultsLimit: Int? = nil,
        completion: @escaping(_ items: [C]) -> ()) {

            // Check if owner exist
            guard let ownerRecord = owner.record else {
                completion([])
                return
            }
            
            // Create NSPredicate
            let recordToMatch = CKRecord.Reference(record: ownerRecord, action: .deleteSelf)
            let predicate = NSPredicate(format: "\(searchField) == %@", recordToMatch)
            
            // Create operation
            let queryOperation = createOperation(
                predicate: predicate,
                recordType: recordType,
                sortDescriptions: sortDescriptions,
                resultsLimit: resultsLimit
            )
            
            // Get items
            var returnedItems: [C] = []
            addRecordMatchedBlock(operation: queryOperation) { item in
                returnedItems.append(item)
            }
            
            // Result
            addQuerryResultBlock(operation: queryOperation) { finished in
                if finished {
                    completion(returnedItems)
                }
            }
            
            addOperation(operation: queryOperation)

        /*
            A função fetchReferences é responsável por buscar os itens referenciados por um determinado item do 
            banco de dados do iCloud. Ela recebe o item proprietário, o nome do campo de pesquisa, o tipo de 
            registro desejado, as descrições de ordenação opcionais, o limite de resultados opcional e uma 
            closure de conclusão para retornar os itens encontrados. Primeiro, a função verifica se o item 
            proprietário existe, verificando se ele possui um registro associado. Se não existir, a função 
            retorna imediatamente uma lista vazia por meio da closure de conclusão. Em seguida, a função cria um 
            objeto CKRecord.Reference com base no registro do item proprietário e a ação de referência definida 
            como .deleteSelf. Esse objeto é usado para criar um predicado NSPredicate que será usado na consulta.
            A função cria uma operação de consulta (queryOperation) utilizando o predicado, o tipo de registro, 
            as descrições de ordenação e o limite de resultados fornecidos. Em seguida, a função define uma 
            variável returnedItems para armazenar os itens retornados. A função adiciona uma closure 
            (addRecordMatchedBlock) que é executada para cada registro correspondente encontrado na operação de 
            consulta. Dentro dessa closure, o item correspondente é mapeado e adicionado à lista returnedItems.
            Depois disso, a função adiciona outra closure (addQueryResultBlock) que é chamada quando a operação de 
            consulta é concluída. Essa closure verifica se a consulta foi finalizada e, se sim, chama a closure de 
            conclusão fornecida, passando a lista returnedItems. Por fim, a função chama a função auxiliar 
            addOperation para adicionar a operação de consulta ao banco de dados do iCloud.
        */
    }
    
    // UPDATE
    
    static func update<T: CKCodable>(item: T, completion: @escaping (Result<CKRecord?, Error>) -> ()) {
        add(item: item, completion: completion)
    }
    
    // DELETE
    
    static func delete<T: CKCodable>(item: T, completion: @escaping (Result<Bool, Error>) -> ()) {
        guard let record = item.record else {
            completion(.failure(iCloudKitError.iCloudDatabaseError))
            return
        }
        delete(record: record, completion: completion)
    }
    
    // Private functions
    
    private static func addRecordMatchedBlock<T:CKCodable>(
        operation: CKQueryOperation,
        completion: @escaping (_ item: T) -> ()) {

            operation.recordMatchedBlock = { (returnedRecordID, returnedResult) in
                switch returnedResult {
                case .success(let record):
                    guard let item = T(record: record) else { return }
                    completion(item)
                case .failure:
                    break
                }
            }

        /*
            A função addRecordMatchedBlock é uma função auxiliar privada que configura uma closure para lidar com 
            registros correspondentes em uma operação de consulta no banco de dados do iCloud. Ela recebe a 
            operação de consulta e uma closure de conclusão que será chamada quando um registro correspondente 
            for encontrado. Dentro da função, é definida a closure recordMatchedBlock, que é acionada para cada 
            registro correspondente retornado pela operação de consulta. A closure recebe o ID do registro 
            retornado e o resultado da consulta. Dentro da closure recordMatchedBlock, é feita uma verificação do 
            resultado retornado. Se for um sucesso, o registro é convertido em um objeto do tipo T 
            (conforme especificado pela restrição genérica) usando o inicializador T(record: record). Em seguida, 
            a closure de conclusão é chamada, passando o item convertido como argumento. Se o resultado for uma 
            falha, ou seja, se ocorrer algum erro ao processar o registro, a execução simplesmente é interrompida.
        */
    }
    
    private static func addQuerryResultBlock(
        operation: CKQueryOperation,
        completion: @escaping(_ finished: Bool) -> ()) {

            operation.queryResultBlock = { returnedResult in
                completion(true)
            }

        /*
            A função addQuerryResultBlock é uma função auxiliar privada que configura uma closure para lidar com o 
            resultado de uma operação de consulta no banco de dados do iCloud. Ela recebe a operação de consulta e 
            uma closure de conclusão que será chamada quando o resultado da consulta estiver disponível.
            Dentro da função, é definida a closure queryResultBlock, que é acionada quando o resultado da 
            consulta é retornado pela operação. Neste caso, a implementação é simples: a closure de conclusão é 
            chamada, passando true como argumento.
        */
    }
    
    private static func createOperation(
        predicate: NSPredicate,
        recordType: CKRecord.RecordType,
        sortDescriptions: [NSSortDescriptor]? = nil,
        resultsLimit: Int? = nil) -> CKQueryOperation {

            let query = CKQuery(recordType: recordType, predicate: predicate)
            query.sortDescriptors = sortDescriptions
            let queryOperation = CKQueryOperation(query: query)
            if let limit = resultsLimit {
                queryOperation.resultsLimit = limit
            }
            return queryOperation

        /*
            A função createOperation é uma função auxiliar privada que cria uma instância de CKQueryOperation com 
            base nos parâmetros fornecidos. Ela recebe um predicado de consulta, um tipo de registro 
            CKRecord.RecordType, uma matriz opcional de descritores de classificação NSSortDescriptor e um 
            limite opcional de resultados. Dentro da função, uma consulta CKQuery é criada usando o tipo de 
            registro e o predicado fornecidos. Em seguida, os descritores de classificação são atribuídos à 
            consulta, se houver algum fornecido. A função cria uma instância de CKQueryOperation com a consulta e, 
            se um limite de resultados for especificado, ele é definido na operação. Retorna a instância de CKQueryOperation criada.
        */
    }

    private static func addOperation(operation: CKDatabaseOperation) {
        CKContainer.default().publicCloudDatabase.add(operation)
    }
    
    private static func save(record: CKRecord, completion: @escaping (Result<CKRecord?, Error>) -> ()) {
        let iCloudPD = CKContainer.default().publicCloudDatabase
        iCloudPD.save(record) { returnedRecord, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(returnedRecord))
            }
        }
    }
    
    private static func delete(record: CKRecord, completion: @escaping (Result<Bool, Error>) -> ()) {
        let iCloudPD = CKContainer.default().publicCloudDatabase
        iCloudPD.delete(withRecordID: record.recordID) { returnedID, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
}
