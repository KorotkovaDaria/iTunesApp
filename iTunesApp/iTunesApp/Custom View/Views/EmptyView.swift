//
//  EmptyView.swift
//  iTunesApp
//
//  Created by Daria on 08.04.2024.
//

import UIKit

class EmptyView: UIView {
    
        let messageLabel = UILabel()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            configure()
        }
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        init(message: String) {
            super.init(frame: .zero)
            self.messageLabel.text = message
            configure()
        }
        
        
        func configure() {
            addSubview(messageLabel)
            messageLabel.textColor     = UIColor(named: Resources.Colors.seaBlue)
            messageLabel.textAlignment = .center
            messageLabel.numberOfLines = 0
            messageLabel.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -150),
                messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
                messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
            ])
        }
}
