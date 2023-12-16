import Foundation

protocol LoadableProtocol {
    
    associatedtype Value
    
    var value: Value? { get }
    var placeholder: Value { get set }
    var error: Error? { get }
    var isLoading: Bool { get }
    var state: LoadingState<Value> { get }
    var valueOrPlaceholder: Value { get }
}

struct Loadable<Value>: LoadableProtocol {
    
    var state: LoadingState<Value> {
        didSet {
            switch state {
            case .loaded(let value):
                placeholder = value
            default:
                break
            }
        }
    }
    var placeholder: Value
    var valueOrPlaceholder: Value { value ?? placeholder }
    
    var value: Value? {
        switch state {
        case .loaded(let value):
            return value
        default:
            return nil
        }
    }
    var error: Error? {
        switch state {
        case .error(let error):
            return error
        default:
            return nil
        }
    }
    var isLoading: Bool {
        switch state {
        case .loading, .initial:
            return true
        default:
            return false
        }
    }
    var isInitial: Bool {
        switch state {
        case .initial:
            return true
        default:
            return false
        }
    }
    
    // MARK: Lifecycle
    static func placeholder(_ placeholder: Value) -> Self {
        return .init(.initial, placeholder: placeholder)
    }
    
    static func loaded(_ value: Value) -> Self {
        return .init(.loaded(value), placeholder: value)
    }
    
    init(_ state: LoadingState<Value> = .initial, placeholder: Value) {
        self.placeholder = placeholder
        self.state = state
    }
}

enum LoadingState<Value> {
    case initial
    case loading
    case error(Error)
    case loaded(Value)
}

extension Loadable {
    
    func map<NewValue>(_ transform: (Value) -> NewValue) -> Loadable<NewValue> {
        switch state {
        case .initial:
            return .init(.initial, placeholder: transform(placeholder))
        case .loading:
            return .init(.loading, placeholder: transform(placeholder))
        case .error(let error):
            return .init(.error(error), placeholder: transform(placeholder))
        case .loaded(let value):
            return .init(.loaded(transform(value)), placeholder: transform(placeholder))
        }
    }
}

extension Array where Element == any LoadableProtocol {
    
    var didAllLoad: Bool {
        return !contains(where: { $0.isLoading })
    }
    
    var firstError: Error? {
        return compactMap({ $0.error })
            .first
    }
}
