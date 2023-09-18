import Foundation

struct LocalNotification {
    var identifier: String
    var title: String
    var body: String
    var dateComponents: DateComponents?
    var repeats: Bool

    internal init (
        identifier: String,
        title: String,
        body: String,
        dateComponents: DateComponents,
        repeats: Bool
    ){
        self.identifier = identifier
        self.title = title
        self.body = body
        self.dateComponents = dateComponents
        self.repeats = repeats
    }

}
