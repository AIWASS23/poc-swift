//
//  Date.swift
//  TestSwiftData
//
//  Created by marcelodearaujo on 29/08/24.
//

import Foundation

struct SMDate {
    static func nowDateString() -> String {
        let locale = Locale(identifier: "pt_BR")
        return Date.now.formatted(.dateTime.locale(locale))
    }
    
    static func howLongAgo(date: Date) -> String {
        let brazil = Locale(identifier: "pt_BR")
        return date.formatted(.relative(presentation: .named, unitsStyle: .wide).locale(brazil))
    }
    static func howLongAgo(dateStr: String) -> String {
        let iso8601String = dateStr
        let formatter = ISO8601DateFormatter()
        let date = formatter.date(from: iso8601String) ?? .now
        return howLongAgo(date: date)
    }
}
