//
//  NetworkManager.swift
//  iTunesApp
//
//  Created by Daria on 07.04.2024.
//

import UIKit

protocol NetworkManagerProtocol {
    func getMediaSearchResult(term: String, completed: @escaping (Result<MediaSearchResult, iTunseError>) -> Void)
}

class NetworkManager: NetworkManagerProtocol {
    static let shared = NetworkManager()
    let baseURL = "https://itunes.apple.com/search?entity=movie,podcast&lang=en_us&term="
    let cache = NSCache<NSString, UIImage>()
    
    func getMediaSearchResult(term: String, completed: @escaping (Result<MediaSearchResult, iTunseError>) -> Void) {
        let searchString = term.replacingOccurrences(of: " ", with: "+")
        let endpoint = "\(baseURL)\(searchString)"
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let mediaSearchResult = try decoder.decode(MediaSearchResult.self, from: data)
                completed(.success(mediaSearchResult))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
}
