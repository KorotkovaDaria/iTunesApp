//
//  DetailsVC.swift
//  iTunesApp
//
//  Created by Daria on 07.04.2024.
//

import UIKit

class DetailsVC: UIViewController {
    // MARK: - Properties
    var selectedMediaItem: MediaResult?
    let scrollView = UIScrollView()
    let stackView = UIStackView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureNavButton()
        if let mediaItem = selectedMediaItem {
            configure(with: mediaItem)
        }
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = UIColor(named: "blue")
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40)
        ])
    }
    
    // MARK: - Configuration
    private func configure(with mediaItem: MediaResult) {
        configureMainImage(with: mediaItem)
        configureTitleLabel(with: mediaItem)
        configureArtistLabel(with: mediaItem)
        configureTypeLabel(with: mediaItem)
        configureCollectionPriceLabel(with: mediaItem)
        configureTrackButton(with: mediaItem)
        configureArtistMovieButton(with: mediaItem)
        //configureArtistPodcastButton(with: mediaItem)
        configureDescriptionLabel(with: mediaItem)
        configureCollectionNameLabel(with: mediaItem)
        
    }
    
    private func configureMainImage(with mediaItem: MediaResult) {
        guard let imageUrl = mediaItem.artworkUrl100 else { return }
        let mainImage = iTunesImageView(frame: .zero)
        mainImage.contentMode = .scaleAspectFit
        mainImage.clipsToBounds = true
        mainImage.translatesAutoresizingMaskIntoConstraints = false
        mainImage.downloadImage(from: imageUrl)
        stackView.addArrangedSubview(mainImage)
        mainImage.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    private func configureTitleLabel(with mediaItem: MediaResult) {
        guard let trackName = mediaItem.trackName else { return }
        let titleLabel = UILabel()
        titleLabel.text = trackName
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        stackView.addArrangedSubview(titleLabel)
    }
    
    private func configureArtistLabel(with mediaItem: MediaResult) {
        let artistName = mediaItem.artistName 
        let artistLabel = UILabel()
        artistLabel.text = "By \(artistName)"
        stackView.addArrangedSubview(artistLabel)
    }
    
    private func configureTypeLabel(with mediaItem: MediaResult) {
        guard var kind = mediaItem.kind else { return }
        if kind == "feature-movie" {
            kind = "movie"
        }
        let typeLabel = UILabel()
        typeLabel.text = "Type: \(kind)"
        stackView.addArrangedSubview(typeLabel)
    }
    
    private func configureCollectionPriceLabel(with mediaItem: MediaResult) {
        guard let collectionPrice = mediaItem.collectionPrice else { return }
        let collectionPriceLabel = UILabel()
        collectionPriceLabel.text = "Collection price: \(collectionPrice)$"
        collectionPriceLabel.numberOfLines = 0
        stackView.addArrangedSubview(collectionPriceLabel)
    }
    
    private func configureTrackButton(with mediaItem: MediaResult) {
        guard mediaItem.trackViewUrl != nil else { return }
        let trackButton = UIButton()
        trackButton.setTitle("More information about this work", for: .normal)
        trackButton.setTitleColor(.white, for: .normal)
        trackButton.backgroundColor = UIColor(named: "sand")
        trackButton.layer.cornerRadius = 5
        trackButton.addTarget(self, action: #selector(openTrackURL), for: .touchUpInside)
        trackButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        stackView.addArrangedSubview(trackButton)
    }
    
    private func configureArtistMovieButton(with mediaItem: MediaResult) {
        guard mediaItem.collectionArtistViewUrl != nil else { return }
        let artistMovieButton = UIButton()
        artistMovieButton.setTitle("More information about this artist", for: .normal)
        artistMovieButton.setTitleColor(.white, for: .normal)
        artistMovieButton.backgroundColor = UIColor(named: "sand")
        artistMovieButton.layer.cornerRadius = 5
        artistMovieButton.addTarget(self, action: #selector(openArtistMovieURL), for: .touchUpInside)
        artistMovieButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        stackView.addArrangedSubview(artistMovieButton)
    }
    private func configureArtistPodcastButton(with mediaItem: MediaResult) {
        guard mediaItem.kind == "podcast", mediaItem.artistViewUrl != nil else { return }
        let artistPodcastButton = UIButton()
        artistPodcastButton.setTitle("More information about this artist", for: .normal)
        artistPodcastButton.setTitleColor(.white, for: .normal)
        artistPodcastButton.backgroundColor = UIColor(named: "sand")
        artistPodcastButton.layer.cornerRadius = 5
        artistPodcastButton.addTarget(self, action: #selector(openArtistPodcastURL), for: .touchUpInside)
        artistPodcastButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        stackView.addArrangedSubview(artistPodcastButton)
    }
    
    private func configureDescriptionLabel(with mediaItem: MediaResult) {
        guard let description = mediaItem.longDescription else { return }
        let descriptionLabel = UILabel()
        descriptionLabel.text = description
        descriptionLabel.numberOfLines = 0
        stackView.addArrangedSubview(descriptionLabel)
    }
    
    private func configureCollectionNameLabel(with mediaItem: MediaResult) {
        guard mediaItem.kind == "podcast", let collectionName = mediaItem.collectionName else { return }
        let collectionNameLabel = UILabel()
        collectionNameLabel.text = "Collection name: \(collectionName)"
        collectionNameLabel.numberOfLines = 0
        stackView.addArrangedSubview(collectionNameLabel)
    }
    
    // MARK: - Actions
    @objc private func openTrackURL() {
        guard let url = selectedMediaItem?.trackViewUrl else { return }
        presentSafariVC(with: url)
    }
    @objc private func openArtistMovieURL() {
        guard let url = selectedMediaItem?.collectionArtistViewUrl else { return }
        presentSafariVC(with: url)
    }
    @objc private func openArtistPodcastURL() {
        guard let url = selectedMediaItem?.artistViewUrl else { return }
        presentSafariVC(with: url)
    }
    
    // MARK: - Navigation Configuration
    private func configureNavButton() {
        let backButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(dismissVC))
        backButton.tintColor = UIColor(named: "seaBlue")
        navigationItem.rightBarButtonItem = backButton
    }
    
    @objc private func dismissVC() {
        dismiss(animated: true)
    }
}

