//
//  MediaItemCollectionViewCell.swift
//  iTunesApp
//
//  Created by Daria on 07.04.2024.
//

import UIKit

class MediaItemCollectionViewCell: UICollectionViewCell {
    //MARK: - property
    static var reuseID = "MediaItemCell"
    let mainImageView = iTunesImageView(frame: .zero)
    let kindTypeLabel = UILabel()
    let trackNameLabel = UILabel()
    let collectionPriceLabel = UILabel()
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - func set
    func set(mediaItem: MediaResult) {
        kindTypeLabel.text = mediaItem.kind?.uppercased()
        if kindTypeLabel.text == "feature-movie".uppercased(){
            kindTypeLabel.text = "movie".uppercased()
        }
        trackNameLabel.text = mediaItem.trackName
        collectionPriceLabel.text = String(mediaItem.collectionPrice ?? 0.0) + "$"
        mainImageView.downloadImage(from: mediaItem.artworkUrl100!)
    }
    //MARK: - configure label
    private func configureLabel() {
        kindTypeLabel.font = .systemFont(ofSize: 10)
        trackNameLabel.font = .systemFont(ofSize: 10)
        collectionPriceLabel.font = .systemFont(ofSize: 10)
        
        kindTypeLabel.textColor = UIColor(named: Resources.Colors.greyText)
        collectionPriceLabel.textColor = UIColor(named: Resources.Colors.seaBlue)
        trackNameLabel.textColor = UIColor(named: Resources.Colors.seaBlue)
        
        kindTypeLabel.numberOfLines = 1
        trackNameLabel.numberOfLines = 1
        collectionPriceLabel.numberOfLines = 1
    }
    //MARK: - configure
    private func configure() {
        addSubview(mainImageView)
        addSubview(kindTypeLabel)
        addSubview(trackNameLabel)
        addSubview(collectionPriceLabel)
        
        kindTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        trackNameLabel.translatesAutoresizingMaskIntoConstraints = false
        collectionPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let padding: CGFloat = 16
        let paddingLabel: CGFloat = 4
        
        NSLayoutConstraint.activate([
            mainImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            mainImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            mainImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            mainImageView.heightAnchor.constraint(equalToConstant: 160),
            mainImageView.widthAnchor.constraint(equalToConstant: 160),
            
            trackNameLabel.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: paddingLabel),
            trackNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            trackNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            collectionPriceLabel.topAnchor.constraint(equalTo: trackNameLabel.bottomAnchor, constant: paddingLabel),
            collectionPriceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            collectionPriceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            kindTypeLabel.topAnchor.constraint(equalTo: collectionPriceLabel.bottomAnchor, constant: paddingLabel),
            kindTypeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            kindTypeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            kindTypeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
        ])
    }
}

