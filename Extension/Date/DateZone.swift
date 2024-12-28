import Foundation

extension DateFormatter {
    
    static let preferedTimeZoneIdentifier = "YOUR_TIMEZONE"
    
    enum Formats: String {
        case yyyyMMddTHHmmssZ = "yyyy-MM-dd'T'HH:mm:ssZ"
        case yyyyMMddTHHmmssSSS = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        case yyyyMMddTHHmmssSSSZ = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        case yyyyMMddTHHmmssSSSZz = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        case yyyyMMddTHHmmss = "yyyy-MM-dd'T'HH:mm:ss"
        case yyyyMMddhhmma = "yyyy-MM-dd hh:mm a"
        case yyyyMMddhhmmss = "yyyy-MM-dd HH:mm:ss"
        case yyyyMMddhhmmsszz = "yyyy-MM-dd HH:mm:ss Z"
        case yyyyMMdd = "yyyy-MM-dd"
        case ddMMyyyy = "dd-MM-yyyy"
        case dMMM = "d MMM"
        case MMMM = "MMMM"
        case MMM = "MMM"
        case HHmmss = "HH:mm:ss"
        case hhmmss = "hh:mm:ss"
        case HHmm = "HH:mm"
        case hhmm = "hh:mm"
        case hhmma = "hh:mm a"
        case ddMMMyyyy = "dd MMM. yyyy"
        case ddMMMyyyy1 = "dd MMM yyyy"
        case ddmmyyyy = "dd/MM/yyyy"
        case dotddmmyyy = "dd.MM.yyyy"
        case MMDDYY = "MM-dd-yyyy"
        case EEEEdMMMyyyy = "EEEE d MMM yyyy"
        case ddmmyyyyHHmmss = "dd/MM/yyyy HH:mm:ss"
        case dMMMyyyy = "d MMM yyyy"
        case dMMMyyy2 = "d MMM, yyyy"
        case MMMdyyy = "MMM d, yyyy"
        case MMddyyyy = "MM/dd/yyyy"
        case dMMMMyyy = "d MMMM yyyy"
        case yyyyd = "yyyy-d"
        case hmma = "h:mm a"
        case ddMMMyyyHHSS = "d MMM yyyy 'at' hh:mm a"
        case mmmmd = "MMMM d"
        case MMMMMYYYY = "MMMM YYYY"
        case ddMMMM = "dd MMMM"
        case dmyyyy = "d/M/yyyy"
        case dd = "dd"
        case yyyy = "yyyy"
        case a = "a"
        case hh = "hh"
        case mm = "mm"
        case eeee = "EEEE"
        case MMddyyyyHHmm = "MM/dd/yyyy HH:mm"
        case dMMMMyyyyWithPractes = "d MMMM, yyyy (HH:mm)"
        
    }
    

    static func gregorian(
        dateFormat: String,
        locale: Locale
    ) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = locale
        formatter.dateFormat = dateFormat
        formatter.calendar = .init(identifier: .gregorian)
        formatter.timeZone = TimeZone.current
        return formatter
    }
    
    func displayString(fromDate date: Date, withFormate format: Formats, locale: Locale = Locale.current) -> String {
        let formatter: DateFormatter = .gregorian(
            dateFormat: format.rawValue,
            locale: locale
        )
        let dateString = formatter.string(from: date)
        return dateString
    }
    
    func sendString(fromDate date: Date, withFormate format: Formats) -> String {
        self.dateFormat = format.rawValue
        self.locale = .init(identifier: "en")
        let dateString = string(from: date)
        return dateString
    }
    
    func date(fromString string: String, withFormat format: Formats, locale: Locale = Locale.current) -> Date? {
        let formatter: DateFormatter = .gregorian(
            dateFormat: format.rawValue,
            locale: locale
        )
        
        formatter.timeZone = TimeZone.current
        return formatter.date(from: string)
    }
    
    func timeDuration(_ from: String?,_ to: String?) -> String {
        guard let fromDate = from,
              let toDate = to,
              let dateFrom = date(fromString: fromDate, withFormat: .hhmmss),
              let dateTo = date(fromString: toDate, withFormat: .hhmmss) else {
            return "0"
        }
        let difference = dateTo.timeIntervalSince1970 - dateFrom.timeIntervalSince1970
        return difference.stringTime
    }
}

extension TimeInterval{
    
    var milliseconds: Int {
        return Int((truncatingRemainder(dividingBy: 1)) * 1000)
    }
    
    var minutes: Int {
        return (Int(self) / 60 ) % 60
    }
    
    var hours: Int {
        return Int(self) / 3600
    }
    
    var stringTime: String {
        if hours != 0 {
            return "\(hours) Uhr \(minutes) min"
        } else if minutes != 0 {
            return "\(minutes) min"
        } else {
            return .na
        }
    }
}
