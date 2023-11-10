//
//  Loadable.swift
//
//
//  Created by Kevin van den Hoek on 27/10/2023.
//

import Foundation

public protocol LoadableProtocol {
    
    associatedtype Value
    
    var value: Value? { get }
    var placeholder: Value { get set }
    var error: Error? { get }
    var isLoading: Bool { get }
    var state: LoadingState<Value> { get }
    var valueOrPlaceholder: Value { get }
}

public struct Loadable<Value>: LoadableProtocol {
    
    public var state: LoadingState<Value> {
        didSet {
            switch state {
            case .loaded(let value):
                placeholder = value
            default:
                break
            }
        }
    }
    public var placeholder: Value
    public var valueOrPlaceholder: Value { value ?? placeholder }
    
    public var value: Value? {
        switch state {
        case .loaded(let value):
            return value
        default:
            return nil
        }
    }
    public var error: Error? {
        switch state {
        case .error(let error):
            return error
        default:
            return nil
        }
    }
    public var isLoading: Bool {
        switch state {
        case .loading, .initial:
            return true
        default:
            return false
        }
    }
    public var isInitial: Bool {
        switch state {
        case .initial:
            return true
        default:
            return false
        }
    }
    
    // MARK: Lifecycle
    public static func placeholder(_ placeholder: Value) -> Self {
        return .init(.initial, placeholder: placeholder)
    }
    
    public static func loaded(_ value: Value) -> Self {
        return .init(.loaded(value), placeholder: value)
    }
    
    public init(_ state: LoadingState<Value> = .initial, placeholder: Value) {
        self.placeholder = placeholder
        self.state = state
    }
}

public enum LoadingState<Value> {
    case initial
    case loading
    case error(Error)
    case loaded(Value)
}

public extension Loadable {
    
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

public extension Array where Element == any LoadableProtocol {
    
    var didAllLoad: Bool {
        return !contains(where: { $0.isLoading })
    }
    
    var firstError: Error? {
        return compactMap({ $0.error })
            .first
    }
}
