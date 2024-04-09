//
//  iTunesLable.swift
//  iTunesApp
//
//  Created by Daria on 09.04.2024.
//

import UIKit

class iTunesLable: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init (textAlignment: NSTextAlignment, color: String, numberOfLines: Int) {
        super.init(frame: .zero)
        self.textAlignment = textAlignment
        self.textColor     = UIColor(named: color)
        self.numberOfLines = numberOfLines
        configure()
    }
    
    private func configure() {
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor        = 0.75
        lineBreakMode             = .byWordWrapping
        numberOfLines             = 0
        translatesAutoresizingMaskIntoConstraints = false
    }

}
