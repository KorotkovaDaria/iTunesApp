//
//  iTunesLabel.swift
//  iTunesApp
//
//  Created by Daria on 09.04.2024.
//

import UIKit

class iTunesLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init (textAlignment: NSTextAlignment, color: UIColor?, numberOfLines: Int) {
        self.init(frame: .zero)
        self.textAlignment = textAlignment
        self.textColor     = color
        self.numberOfLines = numberOfLines
    }
    
    private func configure() {
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor        = 0.75
        lineBreakMode             = .byWordWrapping
        translatesAutoresizingMaskIntoConstraints = false
    }

}
