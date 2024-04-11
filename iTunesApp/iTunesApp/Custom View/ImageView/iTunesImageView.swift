//
//  iTunesImageView.swift
//  iTunesApp
//
//  Created by Daria on 07.04.2024.
//

import UIKit

class iTunesImageView: UIImageView {

    let plaseholderImage = Resources.ImageTitle.plaseholderImage
    let cache            = NetworkManager.shared.cache
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.cornerRadius = 10
        clipsToBounds      = true
        contentMode        = .scaleAspectFill
        image              = plaseholderImage
        translatesAutoresizingMaskIntoConstraints = false
    }
    
}
