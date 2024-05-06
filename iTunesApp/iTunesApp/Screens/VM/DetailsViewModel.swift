//
//  DetailsViewModel.swift
//  iTunesApp
//
//  Created by Daria on 06.05.2024.
//

import UIKit

class DetailsViewModel {
    var selectedMediaItem: MediaResult?
    var selectedLookupItem: [MediaResult]?
    weak var viewController: UIViewController?
    
    
    init(selectedMediaItem: MediaResult) {
            self.selectedMediaItem = selectedMediaItem
        }
    
    func fetchMediaItem(id: MediaResult?, completion: @escaping (Result<[MediaResult], Error>) -> Void) {
        guard let amgArtistId = id?.amgArtistId else { return }
        NetworkManager.shared.getMediaLookupResult(amgArtist: amgArtistId) { result in
            switch result {
            case .success(let mediaLookupItem):
                self.selectedLookupItem = mediaLookupItem.results
                completion(.success(mediaLookupItem.results))
            case .failure(let error):
                self.viewController?.presentAlertOnMainTread(title: Resources.AlertText.titleWrongAlert, message: "\(Resources.AlertText.messageEnglishTextAlert)\(error.rawValue)", buttonTitle: Resources.AlertText.okButtonTitleAlert)
            }
        }
    }
}


