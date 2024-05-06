//
//  SearchViewController.swift
//  iTunesApp
//
//  Created by Daria on 07.04.2024.
//


import UIKit

class SearchViewController: UIViewController, SearchViewModelDelegate {
    
    
    //MARK: - enum
    enum Section { case main }
    // MARK: - Properties
    let searchController = UISearchController(searchResultsController: ResultsVC())
    var collectionView: UICollectionView!
    var dataSourse: UICollectionViewDiffableDataSource<Section, MediaResult>!
    
    var viewModel = SearchViewModel()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        
        configureSearchController()
        configureSearchViewController()
        configureCollectionView()
        configureDataSourse()
        
        viewModel.loadSearchTerms()
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
    
    func updateData(on mediaItem: [MediaResult]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section,MediaResult>()
        snapshot.appendSections([.main])
        snapshot.appendItems(mediaItem)
        DispatchQueue.main.async { self.dataSourse.apply(snapshot, animatingDifferences: true) }
    }
    
    func updateSearchResults() {
        updateData(on: viewModel.searchResults)
    }
    
    func displayError(title: String, message: String) {
        presentAlertOnMainTread(title: title, message: message, buttonTitle: "OK")
    }
    
    func configureDataSourse() {
        dataSourse = UICollectionViewDiffableDataSource<Section, MediaResult>(collectionView: collectionView, cellProvider: { collectionView, indexPath, mediaItem in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaItemCollectionViewCell.reuseID, for: indexPath) as! MediaItemCollectionViewCell
            cell.set(mediaItem: mediaItem)
            return cell
        })
    }
}
//MARK: - extension collection view controller
extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.searchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaItemCollectionViewCell.reuseID, for: indexPath) as! MediaItemCollectionViewCell
        cell.prepareForReuse()
        let mediaItem = viewModel.searchResults[indexPath.item]
        cell.set(mediaItem: mediaItem)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMediaItem                = viewModel.searchResults[indexPath.item]
        let destVC                           = DetailsVC()
        destVC.viewModel = DetailsViewModel(selectedMediaItem: selectedMediaItem)
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
        let filteredTerms = viewModel.previouslyEnteredSearchTerms.filter { $0.lowercased().contains(searchText.lowercased()) }
        (searchController.searchResultsController as? ResultsVC)?.searchSuggestions = filteredTerms
        (searchController.searchResultsController as? ResultsVC)?.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines), !searchText.isEmpty {
            let isEnglishAndDigits = searchText.range(of: #"^[a-zA-Z0-9 ]+$"#, options: .regularExpression) != nil
            
            if isEnglishAndDigits {
                viewModel.fetchMediaItem(term: searchText)
                if !viewModel.previouslyEnteredSearchTerms.contains(where: { $0.lowercased() == searchText.lowercased() }) {
                    viewModel.previouslyEnteredSearchTerms.insert(searchText, at: 0)
                    if viewModel.previouslyEnteredSearchTerms.count > 5 {
                        viewModel.previouslyEnteredSearchTerms.removeLast()
                    }
                    viewModel.saveSearchTerms()
                }
                searchController.dismiss(animated: true)
            } else {
                presentAlertOnMainTread(title: "Only English Language", message: "Please enter your search term in English.", buttonTitle: "OK")
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchResults.removeAll()
        updateData(on: [])
    }
}
