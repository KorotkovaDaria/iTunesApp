//
//  Resources.swift
//  iTunesApp
//
//  Created by Daria on 07.04.2024.
//

import UIKit

enum Resources {
    enum Colors {
        static var seaBlue  = UIColor(named: "seaBlue")
        static var blue     = UIColor(named: "blue")
        static var sand     = UIColor(named: "sand")
        static var white    = UIColor(named: "white")
        static var black    = UIColor(named: "black")
        static var blueGrey = UIColor(named: "blueGrey")
        static var greyText = UIColor(named: "greyText")
    }
    
    enum ImageTitle {
        static var plaseholderImage  = UIImage(named: "plaseholderImage")
        static var arrowUpBackward   = UIImage(systemName: "arrow.up.backward")
    }
    
    enum MediaType {
        static let podcast = "podcast"
        static let movie   = "movie"
        static let album   = "album"
    }
    
    enum AlertText {
        static var titleWrongAlert = "You wrote something wrong!"
        static var titleUniqueAlert = "You are so unique!"
        static var titleOnlyEnglishAlert = "Only English Language"
        static var messageEnterOnlyEnglishAlert = "Please enter your search term in English."
        static var messageUnfortunatelyRequestAlert = "Unfortunately, there is nothing matching your request. We will try to take this into account next time"
        static var messageEnglishTextAlert = "Please make sure you make your request in English and write the existing text.\n"
        static var okButtonTitleAlert = "OK"
    }

}
