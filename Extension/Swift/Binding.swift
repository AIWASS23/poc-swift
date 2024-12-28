extension Binding where Value == String {
    func max(_ limit: Int) -> Self {
        if self.wrappedValue.count > limit {
            DispatchQueue.main.async {
                self.wrappedValue = String(self.wrappedValue.prefix(limit))
            }
        }
        return self
    }
    
    func trimmed() -> Binding<String> {
        return Binding<String>(
            get: {
                self.wrappedValue.trimmingCharacters(in: .whitespacesAndNewlines)
            },
            set: {
                self.wrappedValue = $0.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        )
    }
}