//
//  DetailsVC.swift
//  iTunesApp
//
//  Created by Daria on 07.04.2024.
//

import UIKit

class DetailsVC: UIViewController {
    // MARK: - Properties
    var viewModel: DetailsViewModel?
    var mainImage: iTunesImageView!
    let scrollView = UIScrollView()
    let stackView  = UIStackView()
    let tableView  = ContentSizeTableView()
    var kindType   = ""
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStackView()
        setupScrollView()
        configureNavButton()
        if let mediaItem = viewModel?.selectedMediaItem {
            configure(with: mediaItem)
            viewModel?.fetchMediaItem(id: mediaItem) { _ in
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - UI Setup
    private func setupStackView() {
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
    
    private func setupScrollView() {
        view.backgroundColor = Resources.Colors.blue
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
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
        
        configureTrackHyperlink(with: mediaItem)
        configureArtistHyperlink(with: mediaItem)
        
        configureDescriptionTextLabel(with: mediaItem)
        configureDescriptionLabel(with: mediaItem)
        configureDescriptionForPodcastLabel(with: mediaItem)
        configureBestAlbumsLabel(with: mediaItem)
        
        table(with: mediaItem)
    }
    // MARK: - image
    private func configureMainImage(with mediaItem: MediaResult) {
        guard let imageUrl = mediaItem.artworkUrl100 else { return }
        mainImage = iTunesImageView(frame: .zero)
        NetworkManager.shared.downloadImage(from: imageUrl) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async { self.mainImage.image = image }
        }
        mainImage.contentMode   = .scaleAspectFit
        mainImage.clipsToBounds = true
        
        stackView.addArrangedSubview(mainImage)
        mainImage.heightAnchor.constraint(equalToConstant: 400).isActive = true
    }
    // MARK: - label
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
        let updatedKind = kind == "feature-movie" ? Resources.MediaType.movie : kind
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
    // MARK: - Hyperlink
    private func configureTrackHyperlink(with mediaItem: MediaResult) {
        guard let url = mediaItem.trackViewUrl ?? mediaItem.collectionViewUrl else { return }
        configureLink(title: "Click to view this \(kindType)", url: url)
    }
    
    private func configureArtistHyperlink(with mediaItem: MediaResult) {
        var url: String?
        switch kindType {
        case Resources.MediaType.podcast:
            url = mediaItem.artistViewUrl
        case Resources.MediaType.movie:
            url = mediaItem.collectionArtistViewUrl
        case Resources.MediaType.album:
            url = mediaItem.artistViewUrl
        default:
            break
        }
        guard let artistURL = url else { return }
        configureLink(title: "Click to find out more information about the author", url: artistURL)
    }
    
    
    // MARK: - label
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
        guard kindType == Resources.MediaType.podcast || kindType == Resources.MediaType.album, let trackCount = mediaItem.trackCount else { return }
        configureLabel(title: "Track count: \(trackCount)", isBold: false)
    }
    
    private func configureBestAlbumsLabel (with mediaItem: MediaResult) {
        guard let _ = mediaItem.amgArtistId, kindType == Resources.MediaType.album else { return }
        configureLabel(title: "Best albums by \(mediaItem.artistName)", isBold: true)
    }
    // MARK: - table
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
    
    //MARK: - Helper
    
    private func configureLabel(title: String?, isBold: Bool = false) {
        guard let title = title else { return }
        let label = iTunesLabel(textAlignment: .left, color: Resources.Colors.black, numberOfLines: 0)
        label.text = title
        label.font = isBold ? UIFont.boldSystemFont(ofSize: 20) : UIFont.systemFont(ofSize: 17)
        stackView.addArrangedSubview(label)
    }
    
    private func configureLink(title: String, url: String) {
        let attributedString = NSMutableAttributedString(string: title)
        let range            = NSRange(location: 0, length: attributedString.length)
        attributedString.addAttribute(.link, value: url, range: range)
        
        let linkLabel            = iTunesLabel()
        linkLabel.attributedText = attributedString
        linkLabel.numberOfLines  = 0
        linkLabel.isUserInteractionEnabled = true
        linkLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openLink(_:))))
        stackView.addArrangedSubview(linkLabel)
    }
    
    // MARK: - Actions
    @objc private func openLink(_ sender: UITapGestureRecognizer) {
        guard let label   = sender.view as? UILabel,
              let url     = label.attributedText?.attribute(.link, at: 0, effectiveRange: nil) as? String,
              let linkURL = URL(string: url) else { return }
        UIApplication.shared.open(linkURL)
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
//MARK: - Extension

extension DetailsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let countItem = viewModel?.selectedLookupItem?.filter({ $0.artistType != "Artist" }).count else { return 0 }
        
        return countItem
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: BestAlbumCell.reuseID, for: indexPath) as! BestAlbumCell
        let index = indexPath.row
        guard let album = viewModel?.selectedLookupItem?.filter({ $0.artistType != "Artist" })[index] else {
            return cell
        }
        let arrowImage           = Resources.ImageTitle.arrowUpBackward
        let arrowImageView       = UIImageView(image: arrowImage)
        arrowImageView.tintColor = Resources.Colors.blue
        cell.set(mediaItem: album)
        cell.textLabel?.numberOfLines = 0
        cell.selectionStyle  = .none
        cell.backgroundColor = Resources.Colors.seaBlue
        cell.accessoryView   = arrowImageView
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index         = indexPath.row + 1
        let selectedAlbum = viewModel?.selectedLookupItem?[index]
        guard let url = selectedAlbum?.collectionViewUrl else { return }
        presentSafariVC(with: url)
    }
}
