//
//  SearchViewModel.swift
//  iTunesApp
//
//  Created by Daria on 06.05.2024.
//

import UIKit

protocol SearchViewModelDelegate: AnyObject {
    func updateSearchResults()
    func displayError(title: String, message: String)
    
}

class SearchViewModel {
    weak var delegate: SearchViewModelDelegate?
    weak var viewController: UIViewController?
    
    var searchResults: [MediaResult] = []
    var previouslyEnteredSearchTerms: [String] = []
    
    func fetchMediaItem(term: String) {
        viewController?.showLoadingView()
        NetworkManager.shared.getMediaSearchResult(term: term) { [weak self] result in
            self?.viewController?.dismissLoadingView()
            guard let self = self else { return }
            switch result {
            case .success(let mediaItem):
                self.searchResults = mediaItem.results
                //self.updateData(on: self.searchResults)
                DispatchQueue.main.async {
                    self.delegate?.updateSearchResults()
                }
                if self.searchResults.isEmpty {
                    self.delegate?.displayError(title: "You are so unique!", message: "Unfortunately, there is nothing matching your request. We will try to take this into account next time")
                }
            case .failure(let error):
                self.delegate?.displayError(title: "You wrote something wrong!", message: "Please make sure you make your request in English and write the existing text.\n\(error.rawValue)")
            }
        }
    }
    
    func saveSearchTerms() {
        UserDefaultsManager.shared.saveSearchTerms(previouslyEnteredSearchTerms)
    }
    
    func loadSearchTerms() {
        previouslyEnteredSearchTerms = UserDefaultsManager.shared.loadSearchTerms()
    }
}
