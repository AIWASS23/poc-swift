import Foundation

extension DefaultStringInterpolation {
    
    mutating func appendInterpolation<T>(
        _ value: T?,
        placeholder: @autoclosure () -> String,
        where predicate: ((T) throws -> Bool)? = nil
    ) rethrows {
        switch value {
        case let .some(value) where try predicate?(value) != false:
            appendInterpolation(value)
        default:
            appendInterpolation(placeholder())
        }
    }
}
