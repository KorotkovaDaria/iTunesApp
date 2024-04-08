//
//  DetailsVC.swift
//  iTunesApp
//
//  Created by Daria on 07.04.2024.
//

import UIKit

class DetailsVC: UIViewController {
    //MARK: - property
    var selectedMediaItem: MediaResult?
    let scrollView = UIScrollView()
    let stackView  = UIStackView()
    
    //MARK: - live cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: Resources.Colors.blue)
        configureNavButton()
        setupUI()
        
        if let mediaItem = selectedMediaItem {
            configure(with: mediaItem)
        }
    }
    
    //MARK: - setup UI
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        scrollView.addSubview(stackView)
        stackView.axis         = .vertical
        stackView.alignment    = .fill
        stackView.distribution = .fill
        stackView.spacing      = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40)
        ])
    }
    
    private func configure(with mediaItem: MediaResult) {
        if let imageUrl = mediaItem.artworkUrl100 {
            let mainImage           = iTunesImageView(frame: .zero)
            mainImage.contentMode   = .scaleAspectFit
            mainImage.clipsToBounds = true
            mainImage.translatesAutoresizingMaskIntoConstraints = false
            mainImage.downloadImage(from: imageUrl)
            stackView.addArrangedSubview(mainImage)
            
            mainImage.heightAnchor.constraint(equalToConstant: 200).isActive = true
        }
        
        
        if let trackName = mediaItem.trackName {
            let titleLabel  = UILabel()
            titleLabel.text = trackName
            titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
            stackView.addArrangedSubview(titleLabel)
        }
        
        let artistName   = mediaItem.artistName
        let artistLabel  = UILabel()
        artistLabel.text = "By \(artistName)"
        
        stackView.addArrangedSubview(artistLabel)
        
        if let kind = mediaItem.kind {
            let typeLabel  = UILabel()
            typeLabel.text = "Type: \(kind)"
            
            stackView.addArrangedSubview(typeLabel)
        }
        
        if let collectionPrice = mediaItem.collectionPrice {
            let collectionPriceLabel           = UILabel()
            collectionPriceLabel.text          = "Collection price: \(collectionPrice)$"
            collectionPriceLabel.numberOfLines = 0
            
            stackView.addArrangedSubview(collectionPriceLabel)
        }
        
        
        if let description = mediaItem.longDescription {
            let descriptionLabel           = UILabel()
            descriptionLabel.text          = description
            descriptionLabel.numberOfLines = 0
            
            stackView.addArrangedSubview(descriptionLabel)
        }
        
        if mediaItem.kind == "podcast" {
            if let collectionName                 = mediaItem.collectionName {
                let collectionNameLabel           = UILabel()
                collectionNameLabel.text          = "Collection name: \(collectionName)"
                collectionNameLabel.numberOfLines = 0
                
                stackView.addArrangedSubview(collectionNameLabel)
            }
        }

    }
    //MARK: - configure nav
    func configureNavButton() {
        let backButton                    = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(dismissVC))
        backButton.tintColor              = UIColor(named: Resources.Colors.seaBlue)
        navigationItem.rightBarButtonItem = backButton
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
}

