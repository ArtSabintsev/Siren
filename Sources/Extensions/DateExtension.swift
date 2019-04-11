//
//  DateExtension.swift
//  Siren
//
//  Created by Arthur Sabintsev on 3/21/17.
//  Copyright © 2017 Sabintsev iOS Projects. All rights reserved.
//

import Foundation

// `Date` Extension for Siren.
extension Date {
    /// The amount of days passed from a specific source date.
    ///
    /// - Parameter date: The source date.
    /// - Returns: The amount of days passed since the source date.
    static func days(since date: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: date, to: Date())
        return components.day ?? 0
    }

    /// The amount of days passed from a specific source date string.
    ///
    /// - Parameter dateString: The source date string.
    /// - Returns: The amount of days passed since the source date.
    static func days(since dateString: String,
                     locale: Locale = Locale(identifier: "en_US_POSIX"),
                     dateFormat: String = "yyyy-MM-dd'T'HH:mm:ss'Z'",
                     timeZone: TimeZone? = TimeZone(secondsFromGMT: 0)) -> Int? {
        let dateformatter = DateFormatter()
        dateformatter.locale = locale
        dateformatter.dateFormat = dateFormat
        dateformatter.timeZone = timeZone
        
        guard let date = dateformatter.date(from: dateString) else {
            return nil
        }
        
        return days(since: date)
    }
}
