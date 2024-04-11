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

}
