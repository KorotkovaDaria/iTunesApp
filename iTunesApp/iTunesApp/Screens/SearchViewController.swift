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
    //MARK: - property
    let searchController = UISearchController(searchResultsController: ResultsVC())
    var searchResults: [MediaResult] = []
    var previouslyEnteredSearchTerms: [String] = []
    var collectionView: UICollectionView!
    var dataSourse: UICollectionViewDiffableDataSource<Section, MediaResult>!
    
    //MARK: - live cycle
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
        view.backgroundColor = UIColor(named: Resources.Colors.blue)
    }
    
    //MARK: - configure collection view controller
    func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createTwoColumnFlowLayout())
        collectionView.backgroundColor = UIColor(named: Resources.Colors.blue)
        collectionView.register(MediaItemCollectionViewCell.self, forCellWithReuseIdentifier: MediaItemCollectionViewCell.reuseID)
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
    }
    
    func createTwoColumnFlowLayout() -> UICollectionViewFlowLayout {
        let width                       = view.bounds.width
        let padding: CGFloat            = 2
        let minimumItemSpacing: CGFloat = 10
        let numberOfColumns             = 2
        let availableWidth              = width - (padding * CGFloat(numberOfColumns + 1)) - (minimumItemSpacing * CGFloat(numberOfColumns - 1))
        let itemWidth                   = availableWidth / CGFloat(numberOfColumns)
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.minimumInteritemSpacing = minimumItemSpacing
        flowLayout.minimumLineSpacing = minimumItemSpacing
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 30)
        return flowLayout
    }
    
    //MARK: - configure search controller
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search"
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.showsSearchResultsButton = true
        navigationItem.searchController = searchController
        navigationItem.searchController?.searchBar.tintColor = UIColor(named: Resources.Colors.seaBlue)
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
                    self.presentAlertOnMainTread(title: "Something went wrong", message: "There is no data for this request ", buttonTitle: "OK")
                }
            case .failure(let error):
                self.presentAlertOnMainTread(title: "Something went wrong", message: error.rawValue, buttonTitle: "OK")
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
        let mediaItem = searchResults[indexPath.item]
        cell.set(mediaItem: mediaItem)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMediaItem = searchResults[indexPath.item]
        let destVC = DetailsVC()
        destVC.selectedMediaItem = selectedMediaItem
        let navController = UINavigationController(rootViewController: destVC)
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
            featchMediaItem(term: searchText)
            previouslyEnteredSearchTerms.insert(searchText, at: 0)
            previouslyEnteredSearchTerms = Array(Set(previouslyEnteredSearchTerms))
            previouslyEnteredSearchTerms = previouslyEnteredSearchTerms.filter { !$0.isEmpty }
            if previouslyEnteredSearchTerms.count > 5 {
                previouslyEnteredSearchTerms.removeLast()
            }
            saveSearchTerms()
            (searchController.searchResultsController as? ResultsVC)?.updateSearchSuggestions(with: previouslyEnteredSearchTerms)
            searchController.dismiss(animated: true)
        }
    }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchResults.removeAll()
            updateData(on: [])
        }
    }

extension SearchViewController {
    func saveSearchTerms() {
        UserDefaults.standard.set(previouslyEnteredSearchTerms, forKey: "PreviouslyEnteredSearchTerms")
    }
    
    func loadSearchTerms() {
        if let savedSearchTerms = UserDefaults.standard.array(forKey: "PreviouslyEnteredSearchTerms") as? [String] {
            previouslyEnteredSearchTerms = savedSearchTerms
        }
    }
}
