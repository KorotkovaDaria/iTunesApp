//
//  TimeFormatter.swift
//  iTunesApp
//
//  Created by Daria on 09.04.2024.
//

import Foundation

struct TimeFormatter {
    static func timeFormater(time millis: Int) -> String {
        let milliseconds: Double = Double(millis)
        let seconds              = milliseconds / 1000 
        let minutes              = seconds / 60
        let hours                = minutes / 60
        
        if hours >= 1 {
            let remainingMinutes = Int(minutes) % 60
            return "\(Int(hours)) h \(remainingMinutes) m"
        } else if minutes >= 1 {
            return "\(Int(minutes)) m"
        } else {
            return "\(Int(seconds)) s"
        }
    }
    
}
