
import Foundation

extension Decodable {
    // Parsing the model in Decodable type.
    
    init?(from data: Data, using decoder: JSONDecoder = .init()) {
        guard let parsed = try? decoder.decode(Self.self, from: data) else { return nil }
        self = parsed
    }
}
