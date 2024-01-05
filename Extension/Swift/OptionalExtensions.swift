import Foundation
extension Optional {
    // Get self of default value (if self is nil).
    ///
    ///		let foo: String? = nil
    ///		print(foo.unwrapped(or: "bar")) -> "bar"
    ///
    ///		let bar: String? = "bar"
    ///		print(bar.unwrapped(or: "foo")) -> "bar"
    ///
    
    func unwrapped(or defaultValue: Wrapped) -> Wrapped {
        return self ?? defaultValue
    }

    // Gets the wrapped value of an optional. If the optional is `nil`, throw a custom error.
    ///
    ///        let foo: String? = nil
    ///        try print(foo.unwrapped(or: MyError.notFound)) -> error: MyError.notFound
    ///
    ///        let bar: String? = "bar"
    ///        try print(bar.unwrapped(or: MyError.notFound)) -> "bar"
    ///
    
    func unwrapped(or error: any Error) throws -> Wrapped {
        guard let wrapped = self else { throw error }
        return wrapped
    }

    // Runs a block to Wrapped if not nil.
    ///
    ///		let foo: String? = nil
    ///		foo.run { unwrappedFoo in
    ///			// block will never run since foo is nil
    ///			print(unwrappedFoo)
    ///		}
    ///
    ///		let bar: String? = "bar"
    ///		bar.run { unwrappedBar in
    ///			// block will run since bar is not nil
    ///			print(unwrappedBar) -> "bar"
    ///		}
    
    func run(_ block: (Wrapped) -> Void) {
        _ = map(block)
    }

    // Assign an optional value to a variable only if the value is not nil.
    ///
    ///     let someParameter: String? = nil
    ///     let parameters = [String: Any]() // Some parameters to be attached to a GET request
    ///     parameters[someKey] ??= someParameter // It won't be added to the parameters dict
    ///
    
    static func ??= (lhs: inout Optional, rhs: Optional) {
        guard let rhs = rhs else { return }
        lhs = rhs
    }

    // Assign an optional value to a variable only if the variable is nil.
    ///
    ///     var someText: String? = nil
    ///     let newText = "Foo"
    ///     let defaultText = "Bar"
    ///     someText ?= newText // someText is now "Foo" because it was nil before
    ///     someText ?= defaultText // someText doesn't change its value because it's not nil
    ///
   
    static func ?= (lhs: inout Optional, rhs: @autoclosure () -> Optional) {
        if lhs == nil {
            lhs = rhs()
        }
    }
}

extension Optional where Wrapped: Collection {
    // Check if optional is nil or empty collection.
    var isNilOrEmpty: Bool {
        return self?.isEmpty ?? true
    }

    // Returns the collection only if it is not nil and not empty.
    var nonEmpty: Wrapped? {
        return (self?.isEmpty ?? true) ? nil : self
    }
}


extension Optional where Wrapped: RawRepresentable, Wrapped.RawValue: Equatable {

    // Returns a Boolean value indicating whether two values are equal.
    //
    // Equality is the inverse of inequality. For any values `a` and `b`,
    // `a == b` implies that `a != b` is `false`.
    //
    
    @inlinable static func == (lhs: Optional, rhs: Wrapped.RawValue?) -> Bool {
        return lhs?.rawValue == rhs
    }

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
   
    @inlinable static func == (lhs: Wrapped.RawValue?, rhs: Optional) -> Bool {
        return lhs == rhs?.rawValue
    }

    /// Returns a Boolean value indicating whether two values are not equal.
    ///
    /// Inequality is the inverse of equality. For any values `a` and `b`,
    /// `a != b` implies that `a == b` is `false`.
    ///
    
    @inlinable static func != (lhs: Optional, rhs: Wrapped.RawValue?) -> Bool {
        return lhs?.rawValue != rhs
    }

    /// Returns a Boolean value indicating whether two values are not equal.
    ///
    /// Inequality is the inverse of equality. For any values `a` and `b`,
    /// `a != b` implies that `a == b` is `false`.
    ///
    
    @inlinable static func != (lhs: Wrapped.RawValue?, rhs: Optional) -> Bool {
        return lhs != rhs?.rawValue
    }

}

infix operator ??=: AssignmentPrecedence
infix operator ?=: AssignmentPrecedence
