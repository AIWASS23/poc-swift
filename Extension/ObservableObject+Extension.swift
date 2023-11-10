import Foundation
import Combine

public extension ObservableObject {
    
    /// Load data and update the property specified by a key path.
    ///
    /// - Parameters:
    ///   - keyPath: The key path of the property to be updated with the loading result.
    ///   - reload: A boolean flag to indicate if the loading should be performed even if the property is already loaded. Default is `false`.
    ///   - loader: An asynchronous closure that fetches the data and returns the value or throws an error.
    func load<Value>(
        into keyPath: ReferenceWritableKeyPath<Self, Loadable<Value>>,
        ignoreIfLoaded: Bool = false,
        loader: @escaping () async throws -> Value
    ) {
        Task {
            try? await loadAsync(into: keyPath, ignoreIfLoaded: ignoreIfLoaded, loader: loader)
        }
    }
    
    /// Load data and update the property specified by a key path.
    ///
    /// - Parameters:
    ///   - keyPath: The key path of the property to be updated with the loading result.
    ///   - reload: A boolean flag to indicate if the loading should be performed even if the property is already loaded. Default is `false`.
    ///   - loader: An asynchronous closure that fetches the data and returns the value or throws an error.
    func loadAsync<Value>(
        into keyPath: ReferenceWritableKeyPath<Self, Loadable<Value>>,
        ignoreIfLoaded: Bool = false,
        loader: () async throws -> Value
    ) async throws -> Value {
        if ignoreIfLoaded, case .loaded(let value) = self[keyPath: keyPath].state {
            return value
        }
        await MainActor.run {
            self[keyPath: keyPath].state = .loading
        }
        do {
            let value = try await loader()
            await MainActor.run {
                self[keyPath: keyPath].state = .loaded(value)
            }
            return value
        } catch {
            await MainActor.run {
                self[keyPath: keyPath].state = .error(error)
            }
            throw error
        }
    }
    
    /// Load data and update the property specified by a key path.
    ///
    /// - Parameters:
    ///   - keyPath: The key path of the property to be updated with the loading result.
    ///   - reload: A boolean flag to indicate if the loading should be performed even if the property is already loaded. Default is `false`.
    ///   - loader: An asynchronous closure that fetches the data and returns the value or throws an error.
    func load<Value>(
        into keyPath: KeyPath<Self, CurrentValueSubject<Loadable<Value>, Never>>,
        ignoreIfLoaded: Bool = false,
        loader: @escaping () async throws -> Value
    ) {
        Task {
            try? await loadAsync(into: keyPath, ignoreIfLoaded: ignoreIfLoaded, loader: loader)
        }
    }
    
    /// Load data and update the property specified by a key path.
    ///
    /// - Parameters:
    ///   - keyPath: The key path of the property to be updated with the loading result.
    ///   - reload: A boolean flag to indicate if the loading should be performed even if the property is already loaded. Default is `false`.
    ///   - loader: An asynchronous closure that fetches the data and returns the value or throws an error.
    func loadAsync<Value>(
        into keyPath: KeyPath<Self, CurrentValueSubject<Loadable<Value>, Never>>,
        ignoreIfLoaded: Bool = false,
        loader: () async throws -> Value
    ) async throws -> Value {
        if ignoreIfLoaded, case .loaded(let value) = self[keyPath: keyPath].value.state {
            return value
        }
        await MainActor.run {
            self[keyPath: keyPath].value.state = .loading
        }
        do {
            let value = try await loader()
            await MainActor.run {
                self[keyPath: keyPath].value.state = .loaded(value)
            }
            return value
        } catch {
            await MainActor.run {
                self[keyPath: keyPath].value.state = .error(error)
            }
            throw error
        }
    }
    
    func funnel<T>(
        _ published: Published<T>.Publisher,
        into keyPath: ReferenceWritableKeyPath<Self, T>,
        scheduler: some Scheduler = DispatchQueue.main,
        onSet: ((T) -> Void)? = nil
    ) -> AnyCancellable {
        return published
            .receive(on: scheduler)
            .sink { [weak self] value in
                self?[keyPath: keyPath] = value
                onSet?(value)
            }
    }
    
    func funnel<T>(
        _ subject: CurrentValueSubject<T, Never>,
        into keyPath: ReferenceWritableKeyPath<Self, T>,
        scheduler: some Scheduler = DispatchQueue.main,
        onSet: ((T) -> Void)? = nil
    ) -> AnyCancellable {
        self[keyPath: keyPath] = subject.value
        onSet?(subject.value)
        return subject
            .receive(on: scheduler)
            .sink { [weak self] value in
                self?[keyPath: keyPath] = value
                onSet?(subject.value)
            }
    }
}
