//
//  iTunesButton.swift
//  iTunesApp
//
//  Created by Daria on 09.04.2024.
//

import UIKit

class iTunesButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(backgroundColor: UIColor?, title: String?, titleColor: UIColor?) {
        self.init(frame: .zero)
        self.backgroundColor  = backgroundColor
        self.setTitle(title ?? "OK", for: .normal)
        self.setTitleColor(titleColor, for: .normal)
    }
    
    
    private func configure() {
        titleLabel?.numberOfLines = 0
        layer.cornerRadius        = 5
        translatesAutoresizingMaskIntoConstraints = false
    }

}
