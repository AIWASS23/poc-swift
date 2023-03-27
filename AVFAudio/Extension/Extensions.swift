import UIKit
import Foundation

extension UIView {

    func addSubviews(_ views: UIView...) {
        views.forEach({
            addSubview($0)
        })
    }
}

extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    static func shortenTimeFormatter(timeInterval: Double) -> String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: TimeInterval(timeInterval))
    }
    static func minuteAndSecondFormatter(timeInterval: Double) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .spellOut
        return formatter.string(from: TimeInterval(timeInterval))!
    }
}

extension Bundle {

    func decode<T: Decodable>(_ type: T.Type, from file: String) -> T? {
        guard let urlQuery = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }

        guard let data = try? Data(contentsOf: urlQuery) else {
            fatalError("Failed to load \(file) from bundle.")
        }

        let decoder = JSONDecoder()

        do {
            let loaded = try decoder.decode(T.self, from: data)
            return loaded
        } catch(let error) {
            print(error)
        }

        return nil
    }
}