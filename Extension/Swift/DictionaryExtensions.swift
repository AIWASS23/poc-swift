import Foundation

extension Dictionary {
    // Creates a Dictionary from a given sequence grouped by a given key path.
   
    init<S: Sequence>(grouping sequence: S, by keyPath: KeyPath<S.Element, Key>) where Value == [S.Element] {
        self.init(grouping: sequence, by: { $0[keyPath: keyPath] })
    }

    // Check if key exists in dictionary.
    ///
    ///        let dict: [String: Any] = ["testKey": "testValue", "testArrayKey": [1, 2, 3, 4, 5]]
    ///        dict.has(key: "testKey") -> true
    ///        dict.has(key: "anotherKey") -> false
    
    func has(key: Key) -> Bool {
        return index(forKey: key) != nil
    }

    // Remove all keys contained in the keys parameter from the dictionary.
    ///
    ///        var dict : [String: String] = ["key1" : "value1", "key2" : "value2", "key3" : "value3"]
    ///        dict.removeAll(keys: ["key1", "key2"])
    ///        dict.keys.contains("key3") -> true
    ///        dict.keys.contains("key1") -> false
    ///        dict.keys.contains("key2") -> false
    ///
    mutating func removeAll<S: Sequence>(keys: S) where S.Element == Key {
        keys.forEach { removeValue(forKey: $0) }
    }

    // Remove a value for a random key from the dictionary.
    @discardableResult
    mutating func removeValueForRandomKey() -> Value? {
        guard let randomKey = keys.randomElement() else { return nil }
        return removeValue(forKey: randomKey)
    }

    // JSON Data from dictionary.
   
    func jsonData(prettify: Bool = false) -> Data? {
        guard JSONSerialization.isValidJSONObject(self) else {
            return nil
        }
        let options = (prettify == true) ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization
            .WritingOptions()
        return try? JSONSerialization.data(withJSONObject: self, options: options)
    }
    
    // JSON String from dictionary.
    
    func jsonString(prettify: Bool = false) -> String? {
        guard JSONSerialization.isValidJSONObject(self) else { return nil }
        let options = (prettify == true) ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization
            .WritingOptions()
        guard let jsonData = try? JSONSerialization.data(withJSONObject: self, options: options) else { return nil }
        return String(data: jsonData, encoding: .utf8)
    }

    // Returns a dictionary containing the results of mapping the given closure over the sequence’s
    // elements.
   
    func mapKeysAndValues<K, V>(_ transform: ((key: Key, value: Value)) throws -> (K, V)) rethrows -> [K: V] {
        return try [K: V](uniqueKeysWithValues: map(transform))
    }

    // Returns a dictionary containing the non-`nil` results of calling the given transformation with
    // each element of this sequence.
    func compactMapKeysAndValues<K, V>(_ transform: ((key: Key, value: Value)) throws -> (K, V)?) rethrows -> [K: V] {
        return try [K: V](uniqueKeysWithValues: compactMap(transform))
    }

    // Creates a new dictionary using specified keys.
    ///
    ///        var dict =  ["key1": 1, "key2": 2, "key3": 3, "key4": 4]
    ///        dict.pick(keys: ["key1", "key3", "key4"]) -> ["key1": 1, "key3": 3, "key4": 4]
    ///        dict.pick(keys: ["key2"]) -> ["key2": 2]
    ///
   
    func pick(keys: [Key]) -> [Key: Value] {
        keys.reduce(into: [Key: Value]()) { result, item in
            result[item] = self[item]
        }
    }
}

extension Dictionary where Value: Equatable {
    // Returns an array of all keys that have the given value in dictionary.
    ///
    ///        let dict = ["key1": "value1", "key2": "value1", "key3": "value2"]
    ///        dict.keys(forValue: "value1") -> ["key1", "key2"]
    ///        dict.keys(forValue: "value2") -> ["key3"]
    ///        dict.keys(forValue: "value3") -> []
    ///
    
    func keys(forValue value: Value) -> [Key] {
        return keys.filter { self[$0] == value }
    }
}


extension Dictionary where Key: StringProtocol {
    // Lowercase all keys in dictionary.
   
    mutating func lowercaseAllKeys() {
        for key in keys {
            if let lowercaseKey = String(describing: key).lowercased() as? Key {
                self[lowercaseKey] = removeValue(forKey: key)
            }
        }
    }
}


extension Dictionary {
    // Deep fetch or set a value from nested dictionaries.

    subscript(path path: [Key]) -> Any? {
        get {
            guard !path.isEmpty else { return nil }
            var result: Any? = self
            for key in path {
                if let element = (result as? [Key: Any])?[key] {
                    result = element
                } else {
                    return nil
                }
            }
            return result
        }
        set {
            if let first = path.first {
                if path.count == 1, let new = newValue as? Value {
                    return self[first] = new
                }
                if var nested = self[first] as? [Key: Any] {
                    nested[path: Array(path.dropFirst())] = newValue
                    return self[first] = nested as? Value
                }
            }
        }
    }
}

extension Dictionary {
    // Merge the keys/values of two dictionaries.

    static func + (lhs: [Key: Value], rhs: [Key: Value]) -> [Key: Value] {
        var result = lhs
        rhs.forEach { result[$0] = $1 }
        return result
    }


    // Append the keys and values from the second dictionary into the first one.
    
    static func += (lhs: inout [Key: Value], rhs: [Key: Value]) {
        rhs.forEach { lhs[$0] = $1 }
    }

    // Remove keys contained in the sequence from the dictionary.
   
    static func - <S: Sequence>(lhs: [Key: Value], keys: S) -> [Key: Value] where S.Element == Key {
        var result = lhs
        result.removeAll(keys: keys)
        return result
    }

    // Remove keys contained in the sequence from the dictionary.
    
    static func -= <S: Sequence>(lhs: inout [Key: Value], keys: S) where S.Element == Key {
        lhs.removeAll(keys: keys)
    }
}
