//
//  BestAlbumCell.swift
//  iTunesApp
//
//  Created by Daria on 11.04.2024.
//


import UIKit

class BestAlbumCell: UITableViewCell {
    //MARK: - property
    static var reuseID           = "BestAlbumCell"
    let albumImageView           = iTunesImageView(frame: .zero)
    let collectionNameTitleLabel = iTunesLabel(textAlignment: .left, color: Resources.Colors.blue, numberOfLines: 0)
    let trackCountLabel          = iTunesLabel(textAlignment: .left, color: Resources.Colors.blue, numberOfLines: 1)
    let artistNameLabel          = iTunesLabel(textAlignment: .left, color: Resources.Colors.greyText, numberOfLines: 1)
    //MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        configureLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - func set
    func set(mediaItem: MediaResult?) {
        guard let name = mediaItem?.collectionName, let count = mediaItem?.trackCount, let artist = mediaItem?.artistName else { return }
        collectionNameTitleLabel.text = name
        trackCountLabel.text = "Track count: \(count)"
        artistNameLabel.text = artist
        if let imageUrl = mediaItem?.artworkUrl100 {
            NetworkManager.shared.downloadImage(from: imageUrl) { [weak self] image in
                guard let self = self else { return }
                DispatchQueue.main.async { self.albumImageView.image = image }
            }
        }
    }
    

    //MARK: - configure label
    private func configureLabel() {
        collectionNameTitleLabel.font = .boldSystemFont(ofSize: 13)
        artistNameLabel.font          = .systemFont(ofSize: 10)
        trackCountLabel.font          = .systemFont(ofSize: 10)
    }
    //MARK: - configure
    private func configure() {
        addSubview(albumImageView)
        addSubview(collectionNameTitleLabel)
        addSubview(trackCountLabel)
        addSubview(artistNameLabel)
        
        let padding: CGFloat      = 8
        let paddingLabel: CGFloat = 4
        
        NSLayoutConstraint.activate([
            albumImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            albumImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            albumImageView.heightAnchor.constraint(equalToConstant: 80),
            albumImageView.widthAnchor.constraint(equalToConstant: 80),
            
            collectionNameTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            collectionNameTitleLabel.leadingAnchor.constraint(equalTo: albumImageView.trailingAnchor, constant: paddingLabel),
            collectionNameTitleLabel.widthAnchor.constraint(equalToConstant: 280),
            collectionNameTitleLabel.heightAnchor.constraint(equalToConstant: 40),
            
            trackCountLabel.topAnchor.constraint(equalTo: collectionNameTitleLabel.bottomAnchor, constant: paddingLabel),
            trackCountLabel.leadingAnchor.constraint(equalTo: albumImageView.trailingAnchor, constant: paddingLabel),
            trackCountLabel.widthAnchor.constraint(equalToConstant: 280),
            trackCountLabel.bottomAnchor.constraint(equalTo: artistNameLabel.topAnchor, constant: -paddingLabel),
            
            artistNameLabel.topAnchor.constraint(equalTo: trackCountLabel.bottomAnchor, constant: paddingLabel),
            artistNameLabel.leadingAnchor.constraint(equalTo: albumImageView.trailingAnchor, constant: paddingLabel),
            artistNameLabel.widthAnchor.constraint(equalToConstant: 280),
            artistNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
            
            
        ])
    }
}

