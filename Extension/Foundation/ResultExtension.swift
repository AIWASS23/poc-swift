import Foundation

/*
    A extension Result é usada para representar o resultado de uma operação que pode 
    falhar devido a algum erro ou ser bem-sucedida. Ele adiciona várias funcionalidades 
    úteis para trabalhar com instâncias de Result, facilitando o tratamento de sucesso e 
    falha de operações assíncronas.

    Aqui está uma explicação de cada método presente na extensão:

    successValue: Retorna o valor de sucesso se a instância de Result for bem-sucedida, 
    ou nil caso contrário.

    mapError: Transforma um erro em outro, mantendo o valor de sucesso inalterado.

    ifSuccess: Executa uma ação se a operação for bem-sucedida, passando o valor de sucesso para a ação.

    ifFailure: Executa uma ação se a operação falhar, passando o erro para a ação.

    forAll: Executa uma ação para todos os casos, bem-sucedidos ou falhos.

    forSuccess: Executa uma ação apenas se a operação for bem-sucedida.

    forFailure: Executa uma ação apenas se a operação falhar.

    on: Executa uma ação em uma fila de despacho específica 
    (por exemplo, uma fila de despacho global ou uma fila de despacho específica do 
    aplicativo).

    fullMap: Aplica uma transformação ao Result completo.

*/

extension Result {
    var successValue: Success? {
        try? get()
    }
    func mapError<SomeError>(_ error: SomeError) -> Result<Success, SomeError> {
        mapError { _ in error }
    }
    
    @discardableResult func ifSuccess(_ action: (Success) -> Void) -> Self {
        if let value = try? get() {
            action(value)
        }
        return self
    }
    
    @discardableResult func ifSuccess(_ action: () -> Void) -> Self {
        ifSuccess { _ in
            action()
        }
    }
    
    @discardableResult func ifFailure(_ action: (Failure) -> Void) -> Self {
        switch self {
        case .failure(let error):
            action(error)
        default:
            break
        }
        return self
    }
    
    @discardableResult func ifFailure(_ action: () -> Void) -> Self {
        ifFailure { _ in
            action()
        }
    }
    
    @discardableResult func forAll(_ action: (Self) -> Void) -> Self {
        action(self)
        return self
    }
    
    @discardableResult func forSuccess(_ action: (Self) -> Void) -> Self {
        ifSuccess {
            action(self)
        }
    }
    
    @discardableResult func forFailure(_ action: (Self) -> Void) -> Self {
        ifFailure { _ in
            action(self)
        }
    }
    
    @discardableResult func on(_ queue: DispatchQueue, _ action: @escaping (Self) -> Void) -> Self {
        queue.async {
            action(self)
        }
        return self
    }
    
    func fullMap<Out, Err: Error>(_ action: (Self) -> Result<Out, Err>) -> Result<Out, Err> {
        action(self)
    }
}

extension Result where Success: OptionalProtocol {
    func mapNil(_ error: Failure) -> Result<Success.Wrapped, Failure> {
        flatMap { $0.flatMap { .success($0) } ?? .failure(error) }
    }
}
