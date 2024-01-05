import Foundation

extension StringProtocol {
    func commonSuffix<T: StringProtocol>(with aString: T, options: String.CompareOptions = []) -> String {
        return String(zip(reversed(), aString.reversed())
            .lazy
            .prefix(while: { (lhs: Character, rhs: Character) in
                String(lhs).compare(String(rhs), options: options) == .orderedSame
            })
            .map { (lhs: Character, _: Character) in lhs }
            .reversed())
    }

    func replacingOccurrences<Target, Replacement>(
        ofPattern pattern: Target,
        withTemplate template: Replacement,
        options: String.CompareOptions = [.regularExpression],
        range searchRange: Range<Self.Index>? = nil) -> String where Target: StringProtocol,
        Replacement: StringProtocol {
        assert(
            options.isStrictSubset(of: [.regularExpression, .anchored, .caseInsensitive]),
            "Invalid options for regular expression replacement")
        return replacingOccurrences(
            of: pattern,
            with: template,
            options: options.union(.regularExpression),
            range: searchRange)
    }
}
