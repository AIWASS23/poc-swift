import Foundation

extension SignedNumeric {

    var string: String {
        return String(describing: self)
    }

    // String with number and current locale currency.
    var asLocaleCurrency: String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        return formatter.string(from: self as! NSNumber)
    }
}


extension SignedNumeric {
    // Spelled out representation of a number.
    ///
    ///        print((12.32).spelledOutString()) // prints "twelve point three two"
    ///
   
    func spelledOutString(locale: Locale = .current) -> String? {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.numberStyle = .spellOut

        guard let number = self as? NSNumber else { return nil }
        return formatter.string(from: number)
    }
}
