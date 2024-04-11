//
//  DetailsVC.swift
//  iTunesApp
//
//  Created by Daria on 07.04.2024.
//

import UIKit


class DetailsVC: UIViewController {
    // MARK: - Properties
    var selectedMediaItem:  MediaResult?
    var selectedLookupItem: [MediaResult]?
    var mainImage:          iTunesImageView!
    let scrollView          = UIScrollView()
    let stackView           = UIStackView()
    let tableView           = ContentSizeTableView()
    var kindType            = ""
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureNavButton()
        if let mediaItem = selectedMediaItem {
            configure(with: mediaItem)
            featchMediaItem(id: mediaItem)
        }
    }

    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = Resources.Colors.blue
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        stackView.axis         = .vertical
        stackView.alignment    = .fill
        stackView.distribution = .fill
        stackView.spacing      = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40)
        ])
        
        scrollView.contentSize = stackView.bounds.size
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
        configureTrackCountLabel(with: mediaItem)
        
        configureTrackButton(with: mediaItem)
        configureArtistButton(with: mediaItem)
        
        configureDescriptionTextLabel(with: mediaItem)
        configureDescriptionLabel(with: mediaItem)
        configureDescriptionForPodcastLabel(with: mediaItem)
        configureBestAlbumsLabel(with: mediaItem)
        
        table(with: mediaItem)
        
    }
    
    private func table (with mediaItem: MediaResult) {
        guard let _ = mediaItem.amgArtistId, kindType == Resources.MediaType.album else { return }
        stackView.addArrangedSubview(tableView)
        tableView.delegate   = self
        tableView.dataSource = self
        tableView.register(BestAlbumCell.self, forCellReuseIdentifier: BestAlbumCell.reuseID)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight          = 96
        tableView.layer.cornerRadius = 10
        tableView.backgroundColor    = Resources.Colors.seaBlue
        tableView.layer.borderColor  = Resources.Colors.sand?.cgColor
        tableView.layer.borderWidth  = 2
        
        NSLayoutConstraint.activate([
            tableView.widthAnchor.constraint(equalTo: stackView.widthAnchor)
        ])
    }
    
    private func configureMainImage(with mediaItem: MediaResult) {
        guard let imageUrl = mediaItem.artworkUrl100 else { return }
        mainImage = iTunesImageView(frame: .zero)
        NetworkManager.shared.downloadImage(from: imageUrl) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async { self.mainImage.image = image }
        }
        mainImage.contentMode = .scaleAspectFit
        mainImage.clipsToBounds = true
        mainImage.translatesAutoresizingMaskIntoConstraints = false

        stackView.addArrangedSubview(mainImage)
        mainImage.heightAnchor.constraint(equalToConstant: 400).isActive = true
    }
    
    private func configureTitleLabel(with mediaItem: MediaResult) {
        let titleText: String
        if let trackName = mediaItem.trackName ?? mediaItem.collectionName {
            titleText = trackName
        } else {
            return
        }
        configureLabel(title: titleText, isBold: true)
    }
    
    private func configureArtistLabel(with mediaItem: MediaResult) {
        configureLabel(title: "By \(mediaItem.artistName)", isBold: false)
    }
    
    
    private func configureTypeLabel(with mediaItem: MediaResult) {
        guard let kind = (mediaItem.collectionType ?? mediaItem.kind)?.lowercased() else { return }
            var updatedKind = ""
            switch kind {
            case "feature-movie":  updatedKind = Resources.MediaType.movie
                default: updatedKind = kind
            }
            kindType = updatedKind
            configureLabel(title: "Type: \(kindType)", isBold: false)
    }
    
    private func configureDateLabel(with mediaItem: MediaResult) {
        guard let date = mediaItem.releaseDate else { return }
        configureLabel(title: "Date release: \(date.convertToDateMonthYearFormat())", isBold: false)
    }
    
    private func configureTimeLabel(with mediaItem: MediaResult) {
        guard let time = mediaItem.trackTimeMillis  else { return }
        let hoursTime = TimeFormatter.timeFormater(time: time)
        configureLabel(title: "Time: \(hoursTime)", isBold: false)
    }
    
    private func configureCollectionPriceLabel(with mediaItem: MediaResult) {
        guard let collectionPrice = mediaItem.collectionPrice else { return }
        configureLabel(title: "Collection price: \(collectionPrice)$", isBold: false)
    }
    
    private func configureTrackButton(with mediaItem: MediaResult) {
        guard let url = mediaItem.trackViewUrl ?? mediaItem.collectionViewUrl else { return }
        configureButton(title: "Click to view this \(kindType)", url: url, action: #selector(openTrackURL))
    }
    
    private func configureArtistButton(with mediaItem: MediaResult) {
        switch kindType {
        case "podcast":
            configureButton(title: "Click to find out more information", url: mediaItem.artistViewUrl, action: #selector(openArtistPodcastURL))
        case "movie":
            configureButton(title: "Click to find out more information", url: mediaItem.collectionArtistViewUrl, action: #selector(openArtistMovieURL))
        case "album":
            configureButton(title: "Click to find out more information", url: mediaItem.artistViewUrl, action: #selector(openArtistAlbumURL))
        default:
            break
        }
    }
    
    private func configureDescriptionTextLabel(with mediaItem: MediaResult) {
        if mediaItem.description == nil && mediaItem.longDescription == nil { return }
        configureLabel(title: "Description", isBold: true)
    }
    
    private func configureDescriptionLabel(with mediaItem: MediaResult) {
        guard let description = mediaItem.longDescription else { return }
        configureLabel(title: description, isBold: false)
    }
    private func configureDescriptionForPodcastLabel(with mediaItem: MediaResult) {
        guard kindType == Resources.MediaType.podcast, let description = mediaItem.description else { return }
        configureLabel(title: description, isBold: false)
    }
    
    private func configureTrackCountLabel(with mediaItem: MediaResult) {
        guard kindType == Resources.MediaType.podcast, let trackCount = mediaItem.trackCount else { return }
        configureLabel(title: "Track count: \(trackCount)", isBold: false)
    }
    
    private func configureBestAlbumsLabel (with mediaItem: MediaResult) {
        guard let _ = mediaItem.amgArtistId, kindType == Resources.MediaType.album else { return }
        configureLabel(title: "Best albums by \(mediaItem.artistName)", isBold: true)
    }
    
    private func configureLabel(title: String?, isBold: Bool = false) {
        guard let title = title else { return }
        let label = iTunesLabel(textAlignment: .left, color: Resources.Colors.black, numberOfLines: 0)
        label.text = title
        label.font = isBold ? UIFont.boldSystemFont(ofSize: 20) : UIFont.systemFont(ofSize: 17)
        stackView.addArrangedSubview(label)
    }

    private func configureButton(title: String?, url: String?, action: Selector) {
        guard let title = title, let _ = url else { return }
        let button = iTunesButton(backgroundColor: Resources.Colors.seaBlue, title: title, titleColor: Resources.Colors.blue)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        stackView.addArrangedSubview(button)
    }
    
    // MARK: - Data
    func featchMediaItem(id: MediaResult?) {
        guard let amgArtistId = id?.amgArtistId else { return }
        showLoadingView()
        NetworkManager.shared.getMediaLookupResult(amgArtist: amgArtistId) { [weak self] result in
            self?.dismissLoadingView()
            guard let self = self else { return }
            switch result {
            case .success(let mediaLookupItem):
                self.selectedLookupItem = mediaLookupItem.results
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                self.presentAlertOnMainTread(title: "You wrote something wrong!", message: "Please make sure you make your request in English and write the existing text.\n\(error.rawValue)", buttonTitle: "OK")
            }
        }
    }
    // MARK: - Actions
    @objc private func openTrackURL() {
        guard let url = selectedMediaItem?.trackViewUrl ?? selectedMediaItem?.collectionViewUrl else { return }
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
    
    @objc private func openArtistAlbumURL() {
        guard let url = selectedMediaItem?.artistViewUrl else { return }
        presentSafariVC(with: url)
    }
    // MARK: - Navigation Configuration
    private func configureNavButton() {
        let backButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(dismissVC))
        backButton.tintColor = Resources.Colors.seaBlue
        navigationItem.rightBarButtonItem = backButton
    }
    
    @objc private func dismissVC() {
        dismiss(animated: true)
    }
}

extension DetailsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let countItem = selectedLookupItem?.count else { return 0 }
        return countItem - 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BestAlbumCell.reuseID, for: indexPath) as! BestAlbumCell
        let index = indexPath.row + 1
        let album = selectedLookupItem?[index]
        cell.set(mediaItem: album)
        cell.textLabel?.numberOfLines = 0
        cell.selectionStyle = .none
        cell.backgroundColor = Resources.Colors.seaBlue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row + 1
        let selectedAlbum = selectedLookupItem?[index]
        guard let url = selectedAlbum?.collectionViewUrl else { return }
        presentSafariVC(with: url)
    }
}
