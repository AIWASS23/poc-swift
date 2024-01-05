import Foundation

extension SignedInteger {
    // Absolute value of integer number.
    var abs: Self {
        return Swift.abs(self)
    }

    // Check if integer is positive.
    var isPositive: Bool {
        return self > 0
    }

    // Check if integer is negative.
    var isNegative: Bool {
        return self < 0
    }

    // Check if integer is even.
    var isEven: Bool {
        return (self % 2) == 0
    }

    // Check if integer is odd.
    var isOdd: Bool {
        return (self % 2) != 0
    }

    // String of format (XXh XXm) from seconds Int.
    var timeString: String {
        guard self > 0 else {
            return "0 sec"
        }
        if self < 60 {
            return "\(self) sec"
        }
        if self < 3600 {
            return "\(self / 60) min"
        }
        let hours = self / 3600
        let mins = (self % 3600) / 60

        if hours != 0, mins == 0 {
            return "\(hours)h"
        }
        return "\(hours)h \(mins)m"
    }
}

extension SignedInteger {

    // Greatest common divisor of integer value and n.
    
    func gcd(of number: Self) -> Self {
        return number == 0 ? self : number.gcd(of: self % number)
    }

    // Least common multiple of integer and n.
   
    func lcm(of number: Self) -> Self {
        return (self * number).abs / gcd(of: number)
    }

    // Ordinal representation of an integer.
    
    func ordinalString(locale: Locale = .current) -> String? {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.numberStyle = .ordinal
        guard let number = self as? NSNumber else { return nil }
        return formatter.string(from: number)
    }
}
