//
//  SearchViewController.swift
//  iTunesApp
//
//  Created by Daria on 07.04.2024.
//


import UIKit

class SearchViewController: UIViewController {
    //MARK: - enum
    enum Section { case main }
    // MARK: - Properties
    let searchController                       = UISearchController(searchResultsController: ResultsVC())
    var searchResults: [MediaResult]           = []
    var previouslyEnteredSearchTerms: [String] = []
    var collectionView: UICollectionView!
    var dataSourse: UICollectionViewDiffableDataSource<Section, MediaResult>!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchController()
        configureSearchViewController()
        configureCollectionView()
        configureDataSourse()
        loadSearchTerms()
    }

    //MARK: - configure search view controller
    func configureSearchViewController() {
        view.backgroundColor = Resources.Colors.blue
    }
    //MARK: - configure collection view controller
    func configureCollectionView() {
        let layout                     = UICollectionViewFlowLayout()
        layout.scrollDirection         = .vertical
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createTwoColumnFlowLayout(in: view))
        collectionView.register(MediaItemCollectionViewCell.self, forCellWithReuseIdentifier: MediaItemCollectionViewCell.reuseID)
        
        collectionView.backgroundColor = Resources.Colors.blue
        collectionView.dataSource      = self
        collectionView.delegate        = self
        
        
        view.addSubview(collectionView)
    }
    
    //MARK: - configure search controller
    func configureSearchController() {
        searchController.searchResultsUpdater                 = self
        searchController.searchBar.delegate                   = self
        searchController.searchBar.placeholder                = "Search"
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.showsSearchResultsButton   = false
        navigationItem.hidesSearchBarWhenScrolling            = false
        navigationItem.searchController                       = searchController
        navigationItem.searchController?.searchBar.tintColor  = Resources.Colors.seaBlue
    }
    //MARK: - data
    func featchMediaItem(term: String) {
        showLoadingView()
        NetworkManager.shared.getMediaSearchResult(term: term) { [weak self] result in
            self?.dismissLoadingView()
            guard let self = self else { return }
            switch result {
            case .success(let mediaItem):
                self.searchResults = mediaItem.results
                self.updateData(on: self.searchResults)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                if self.searchResults.isEmpty {
                    self.presentAlertOnMainTread(title: "You are so unique!", message: "Unfortunately, there is nothing matching your request. We will try to take this into account next time", buttonTitle: "OK")
                }
            case .failure(let error):
                self.presentAlertOnMainTread(title: "You wrote something wrong!", message: "Please make sure you make your request in English and write the existing text.\n\(error.rawValue)", buttonTitle: "OK")
            }
        }
    }
    
    func configureDataSourse() {
        dataSourse = UICollectionViewDiffableDataSource<Section, MediaResult>(collectionView: collectionView, cellProvider: { collectionView, indexPath, mediaItem in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaItemCollectionViewCell.reuseID, for: indexPath) as! MediaItemCollectionViewCell
            cell.set(mediaItem: mediaItem)
            return cell
        })
    }
    
    func updateData(on mediaItem: [MediaResult]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section,MediaResult>()
        snapshot.appendSections([.main])
        snapshot.appendItems(mediaItem)
        DispatchQueue.main.async { self.dataSourse.apply(snapshot, animatingDifferences: true) }
        
    }
}
//MARK: - extension collection view controller
extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaItemCollectionViewCell.reuseID, for: indexPath) as! MediaItemCollectionViewCell
        cell.prepareForReuse()
        let mediaItem = searchResults[indexPath.item]
        cell.set(mediaItem: mediaItem)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMediaItem                = searchResults[indexPath.item]
        let destVC                           = DetailsVC()
        destVC.selectedMediaItem             = selectedMediaItem
        destVC.title                         = selectedMediaItem.trackName ?? selectedMediaItem.collectionName
        let navController                    = UINavigationController(rootViewController: destVC)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
}
//MARK: - extension search controller
extension SearchViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        let filteredTerms = previouslyEnteredSearchTerms.filter { $0.lowercased().contains(searchText.lowercased()) }
        (searchController.searchResultsController as? ResultsVC)?.searchSuggestions = filteredTerms
        (searchController.searchResultsController as? ResultsVC)?.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines), !searchText.isEmpty {
            let isEnglishAndDigits = searchText.range(of: #"^[a-zA-Z0-9 ]+$"#, options: .regularExpression) != nil
            
            if isEnglishAndDigits {
                featchMediaItem(term: searchText)
                if !previouslyEnteredSearchTerms.contains(where: { $0.lowercased() == searchText.lowercased() }) {
                    previouslyEnteredSearchTerms.insert(searchText, at: 0)
                    if previouslyEnteredSearchTerms.count > 5 {
                        previouslyEnteredSearchTerms.removeLast()
                    }
                    saveSearchTerms()
                }
                searchController.dismiss(animated: true)
            } else {
                presentAlertOnMainTread(title: "Only English Language", message: "Please enter your search term in English.", buttonTitle: "OK")
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchResults.removeAll()
        updateData(on: [])
    }
}

extension SearchViewController {
    func saveSearchTerms() {
        UserDefaultsManager.shared.saveSearchTerms(previouslyEnteredSearchTerms)
    }
    
    func loadSearchTerms() {
        previouslyEnteredSearchTerms = UserDefaultsManager.shared.loadSearchTerms()
    }
}
