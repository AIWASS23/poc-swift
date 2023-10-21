import Foundation

enum Response<T, R> {
    case error(String)
    case success(T, aditional: R? = nil)
}
