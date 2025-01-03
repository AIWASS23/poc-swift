import SwiftUI

/*
 a extensão para Binding é uma forma de criar uma ligação (Binding) para um valor opcional (Optional ou Wrapped?) e,
 ao mesmo tempo, mapeá-lo para um valor booleano.

 struct ContentView: View {
     @State private var optionalValue: String?

     var body: some View {
         VStack {
             Toggle("Has Value", isOn: $optionalValue.mappedToBool())

             if let value = optionalValue {
                 Text("Optional Value: \(value)")
             } else {
                 Text("Optional Value is nil")
             }
         }
     }
 }

*/

extension Binding<Bool> {
    init<Wrapped>(bindingOptional: Binding<Wrapped?>) {
        self.init(
            get: { bindingOptional.wrappedValue != nil },
            set: { newValue in
                guard newValue == false else { return }
                bindingOptional.wrappedValue = nil
            }
        )
    }
}

extension Binding {
    func mappedToBool<Wrapped>() -> Binding<Bool> where Value == Wrapped? {
        Binding<Bool>(bindingOptional: self)
    }
}

extension Binding {
	
	static func rawValue<T:RawRepresentable>(for binding:Binding<T>) -> Binding<T.RawValue> where T:Equatable {
		return Binding<T.RawValue>(
		    get: {binding.wrappedValue.rawValue},
			
			set: {
				guard let value = T.init(rawValue:$0) else { return }
				if binding.wrappedValue != value {
					binding.wrappedValue = value
				}
			}
        )
	}
}
