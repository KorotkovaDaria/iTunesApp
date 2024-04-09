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
    var kindType = ""
    
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
        view.backgroundColor = UIColor(named: Resources.Colors.blue)
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
        configureDateLabel(with: mediaItem)
        configureTimeLabel(with: mediaItem)
        configureCollectionPriceLabel(with: mediaItem)
        configureCollectionNameLabel(with: mediaItem)
        configureTrackButton(with: mediaItem)
        configureArtistMovieButton(with: mediaItem)
        configureArtistPodcastButton(with: mediaItem)
        configureDescriptionTextLabel(with: mediaItem)
        configureDescriptionLabel(with: mediaItem)
        configureDescriptionForPodcastLabel(with: mediaItem)
        
    }
    
    private func configureMainImage(with mediaItem: MediaResult) {
        guard let imageUrl = mediaItem.artworkUrl100 else { return }
        let mainImage = iTunesImageView(frame: .zero)
        mainImage.contentMode = .scaleAspectFit
        mainImage.clipsToBounds = true
        mainImage.translatesAutoresizingMaskIntoConstraints = false
        mainImage.downloadImage(from: imageUrl)
        stackView.addArrangedSubview(mainImage)
        mainImage.heightAnchor.constraint(equalToConstant: 400).isActive = true
    }
    
    private func configureTitleLabel(with mediaItem: MediaResult) {
        guard let trackName = mediaItem.trackName else { return }
        let titleLabel = iTunesLable(textAlignment: .left, color: Resources.Colors.black, numberOfLines: 0)
        titleLabel.text = trackName
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        stackView.addArrangedSubview(titleLabel)
    }
    
    private func configureArtistLabel(with mediaItem: MediaResult) {
        let artistName = mediaItem.artistName 
        let artistLabel = iTunesLable(textAlignment: .left, color: Resources.Colors.black, numberOfLines: 0)
        artistLabel.text = "By \(artistName)"
        stackView.addArrangedSubview(artistLabel)
    }
    
    private func configureTypeLabel(with mediaItem: MediaResult) {
        guard var kind = mediaItem.kind else { return }
        if kind == "feature-movie" {
            kind = "movie"
        }
        kindType = kind
        let typeLabel = iTunesLable(textAlignment: .left, color: Resources.Colors.black, numberOfLines: 0)
        typeLabel.text = "Type: \(kind)"
        stackView.addArrangedSubview(typeLabel)
    }
    private func configureDateLabel(with mediaItem: MediaResult) {
        guard let date = mediaItem.releaseDate else { return }
        let dateType = iTunesLable(textAlignment: .left, color: Resources.Colors.black, numberOfLines: 0)
        dateType.text = "Date release: \(date.convertToFormattedString())"
        stackView.addArrangedSubview(dateType)
    }
    
    private func configureTimeLabel(with mediaItem: MediaResult) {
        guard let time = mediaItem.trackTimeMillis  else { return }
        let hoursTime = TimeFormatter.timeFormater(time: time)
        let timeType = iTunesLable(textAlignment: .left, color: Resources.Colors.black, numberOfLines: 0)
        timeType.text = "Time: \(hoursTime)"
        stackView.addArrangedSubview(timeType)
    }
    
    private func configureCollectionPriceLabel(with mediaItem: MediaResult) {
        guard let collectionPrice = mediaItem.collectionPrice else { return }
        let collectionPriceLabel = iTunesLable(textAlignment: .left, color: Resources.Colors.black, numberOfLines: 0)
        collectionPriceLabel.text = "Collection price: \(collectionPrice)$"
        stackView.addArrangedSubview(collectionPriceLabel)
    }
    
    private func configureTrackButton(with mediaItem: MediaResult) {
        guard mediaItem.trackViewUrl != nil else { return }
        let trackButton = iTunesButton(backgroundColor: Resources.Colors.seaBlue, title: "Click to view this \(kindType)" , titleColor: Resources.Colors.blue)
        trackButton.addTarget(self, action: #selector(openTrackURL), for: .touchUpInside)
        trackButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        stackView.addArrangedSubview(trackButton)
    }
    
    private func configureArtistMovieButton(with mediaItem: MediaResult) {
        guard mediaItem.collectionArtistViewUrl != nil else { return }
        let artistMovieButton = iTunesButton(backgroundColor: Resources.Colors.seaBlue, title: "Click to find out more information", titleColor: Resources.Colors.blue)
        artistMovieButton.addTarget(self, action: #selector(openArtistMovieURL), for: .touchUpInside)
        artistMovieButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        stackView.addArrangedSubview(artistMovieButton)
    }
    private func configureArtistPodcastButton(with mediaItem: MediaResult) {
        guard mediaItem.kind == "podcast", mediaItem.artistViewUrl != nil else { return }
        let artistPodcastButton = iTunesButton(backgroundColor: Resources.Colors.seaBlue, title: "Click to find out more information", titleColor: Resources.Colors.blue)
        artistPodcastButton.addTarget(self, action: #selector(openArtistPodcastURL), for: .touchUpInside)
        artistPodcastButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        stackView.addArrangedSubview(artistPodcastButton)
    }
    
    private func configureDescriptionTextLabel(with mediaItem: MediaResult) {
        let descriptionTextLabel = iTunesLable(textAlignment: .left, color: Resources.Colors.black, numberOfLines: 0)
        if mediaItem.description == nil && mediaItem.longDescription == nil {
            return
        }
        descriptionTextLabel.text = "Description"
        descriptionTextLabel.font =  UIFont.boldSystemFont(ofSize: 20)
        stackView.addArrangedSubview(descriptionTextLabel)
    }
    
    private func configureDescriptionLabel(with mediaItem: MediaResult) {
        guard let description = mediaItem.longDescription else { return }
        let descriptionLabel = iTunesLable(textAlignment: .left, color: Resources.Colors.black, numberOfLines: 0)
        descriptionLabel.text = description
        stackView.addArrangedSubview(descriptionLabel)
    }
    private func configureDescriptionForPodcastLabel(with mediaItem: MediaResult) {
        guard mediaItem.kind == "podcast", let description = mediaItem.description else { return }
        let descriptionPodcast = iTunesLable(textAlignment: .left, color: Resources.Colors.black, numberOfLines: 0)
        descriptionPodcast.text = description
        stackView.addArrangedSubview(descriptionPodcast)
    }
    
    private func configureCollectionNameLabel(with mediaItem: MediaResult) {
        guard mediaItem.kind == "podcast", let collectionName = mediaItem.collectionName else { return }
        let collectionNameLabel = iTunesLable(textAlignment: .left, color: Resources.Colors.black, numberOfLines: 0)
        collectionNameLabel.text = "Collection name: \(collectionName)"
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

