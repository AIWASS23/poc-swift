import Foundation

extension Int {

    // String formatted for values over ±1000 (example: 1k, -2k, 100k, 1kk, -5kk..).
    var kFormatted: String {
        var sign: String {
            return self >= 0 ? "" : "-"
        }
        let abs = Swift.abs(self)
        if abs == 0 {
            return "0k"
        } else if abs >= 0, abs < 1000 {
            return "0k"
        } else if abs >= 1000, abs < 1_000_000 {
            return String(format: "\(sign)%ik", abs / 1000)
        }
        return String(format: "\(sign)%ikk", abs / 100_000)
    }

    // Array of digits of integer value.
    var digits: [Int] {
        guard self != 0 else { return [0] }
        var digits = [Int]()
        var number = abs

        while number != 0 {
            let xNumber = number % 10
            digits.append(xNumber)
            number /= 10
        }

        digits.reverse()
        return digits
    }

    // Number of digits of integer value.
    var digitsCount: Int {
        guard self != 0 else { return 1 }
        let number = Double(abs)
        return Int(log10(number) + 1)
    }
}

extension Int {
    func isPrime() -> Bool {
        if self == 2 { return true }

        guard self > 1, self % 2 != 0 else { return false }

        let base = Int(sqrt(Double(self)))
        for int in Swift.stride(from: 3, through: base, by: 2) where self % int == 0 {
            return false
        }
        return true
    }

    func romanNumeral() -> String? {
        guard self > 0 else { 
            return nil
        }
        let romanValues = ["M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"]
        let arabicValues = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1]

        var romanValue = ""
        var startingValue = self

        for (index, romanChar) in romanValues.enumerated() {
            let arabicValue = arabicValues[index]
            let div = startingValue / arabicValue
            for _ in 0..<div {
                romanValue.append(romanChar)
            }
            startingValue -= arabicValue * div
        }
        return romanValue
    }

    func roundToNearest(_ number: Int) -> Int {
        return number == 0 ? self : Int(round(Double(self) / Double(number))) * number
    }
}
