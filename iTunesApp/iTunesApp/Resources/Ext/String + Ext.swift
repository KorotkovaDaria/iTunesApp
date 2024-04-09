//
//  String + Ext.swift
//  iTunesApp
//
//  Created by Daria on 09.04.2024.
//

import Foundation

extension String {
    func convertToDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter.date(from: self)
    }
    
    func convertToFormattedString() -> String {
        guard let date = self.convertToDate() else { return "" }
        let outputFormatter = DateFormatter()
        outputFormatter.locale = Locale(identifier: "en_US_POSIX")
        outputFormatter.dateFormat = "dd MMMM yyyy"
        return outputFormatter.string(from: date)
    }
}
