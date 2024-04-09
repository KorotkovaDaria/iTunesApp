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
    
    init(backgroundColor: String, title: String?, titleColor: String) {
        super.init(frame: .zero)
        configure()
        self.backgroundColor  = UIColor(named: backgroundColor)
        self.setTitle(title ?? "OK", for: .normal)
        self.setTitleColor(UIColor(named: titleColor), for: .normal)
    }
    
    
    private func configure() {
        titleLabel?.numberOfLines = 0
        layer.cornerRadius = 5
        translatesAutoresizingMaskIntoConstraints = false
    }

}
