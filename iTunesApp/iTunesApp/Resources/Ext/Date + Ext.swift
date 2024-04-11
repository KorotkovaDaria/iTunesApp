//
//  Date + Ext.swift
//  iTunesApp
//
//  Created by Daria on 10.04.2024.
//

import Foundation

extension Date {
    
    func convertToDateMonthYearFormat() -> String {
        let dateFormatter        = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: self)
    }
    
}
