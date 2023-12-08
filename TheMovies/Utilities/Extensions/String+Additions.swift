//
//  String+Additions.swift
//  TheMovies
//
//  Created by Tannu Kaushik on 24/04/22.
//

import Foundation
extension String {
    /**
     Method to get date from string
     */
    func getDate(_ dateFormat: String = "yyyy-MM-dd") -> Date? {
        let df = DateFormatter()
        df.dateFormat = dateFormat
        df.locale = Locale(identifier: "en_US_POSIX")
        df.timeZone = TimeZone(identifier: "UTC")
        return df.date(from: self)
    }
}
