import Combine

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Future where Failure == any Error {
    /// Creates a `Future` from an `async` throwing function
    /// - Parameter asyncFunc: The asynchronous throwing function to execute.
    convenience init(asyncFunc: @escaping () async throws -> Output) {
        self.init { promise in
            Task {
                do {
                    let result = try await asyncFunc()
                    promise(.success(result))
                } catch {
                    promise(.failure(error))
                }
            }
        }
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Future where Failure == Never {
    /// Creates a `Future` from an `async` function
    /// - Parameter asyncFunc: The asynchronous function to execute.
    convenience init(asyncFunc: @escaping () async -> Output) {
        self.init { promise in
            Task {
                let result = await asyncFunc()
                promise(.success(result))
            }
        }
    }
}
