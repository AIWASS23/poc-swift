import Foundation

class DateUtil {

    enum AppDateFormat: String {
        
        // MM/dd/yyyy h:mm a -- 10/18/2021 5:30 PM
        case format1 = "MM/dd/yyyy h:mm a"
        // yyyy-MM-dd'T'HH:mm:ss -- 2021-10-18T14:20:00
        case format2 = "yyyy-MM-dd'T'HH:mm:ss"
        // MMM dd, yyyy h:mm a -- OCT 18, 2021 3:45 PM
        case format3 = "MMM dd, yyyy h:mm a"
        // yyyy-MM-dd'T'HH:mm:ssZ -- 2021-10-18T14:25:00+00:00
        case format4 = "yyyy-MM-dd'T'HH:mm:ssZ"
        // MMMM d, yyyy -- October 18, 2019
        case format5 = "MMMM d, yyyy"
        // yyyy-MM-dd HH:mm:ss -- 2021-10-18 13:30:45
        case format6 = "yyyy-MM-dd HH:mm:ss"
        // yyyy-MM-dd'T'HH:mm:ss.SSSSZ -- 2021-10-18T03:15:13.23456+0:00
        case format7 = "yyyy-MM-dd'T'HH:mm:ss.SSSSZ"
        // hh:mm a -- 1:12 PM
        case format8 = "h:mm a"
        // EEEE MMMM d, yyyy -- Tuesday October 18, 2021
        case format9 = "EEEE MMMM d, yyyy"
        // October 18 5:30 PM
        case format10 = "MMMM d h:mm a"
        // October 18
        case format11 = "MMMM d"
        // MM/dd/yyyy -- 10/18/2021
        case format12 = "MM/dd/yyyy"
        // MMMM, yyyy -- October, 2019
        case format14 = "MMMM, yyyy"
        // EE MMM d -- Tuesday October 18
        case format15 = "EE MMM d"
    }
    
    static var formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return dateFormatter
    }()
    
    func convert(input: String, inputFormat: AppDateFormat, outputFormat: AppDateFormat, timeZone: TimeZone = TimeZone.current) -> String? {
        formatter.dateFormat = inputFormat.rawValue
        guard let date = formatter.date(from: input) else {
            return nil
        }
        return convert(input: date, outputFormat: outputFormat, timeZone: timeZone)
    }
    
    func convert(input: Date, outputFormat: AppDateFormat, timeZone: TimeZone = TimeZone.current) -> String? {
        formatter.dateFormat = outputFormat.rawValue
        
        var result: String?
        formatter.timeZone = timeZone
        result = formatter.string(from: input)
        return result ?? formatter.string(from: input)
    }
    
    func produceDate(dateString: String, dateFormat: String, timeZone: TimeZone = TimeZone.current) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = timeZone
        
        return dateFormatter.date(from: dateString)
    }

}
