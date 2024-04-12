//
//  NetworkManager.swift
//  iTunesApp
//
//  Created by Daria on 07.04.2024.
//

import UIKit

protocol NetworkManagerProtocol {
    func getMediaSearchResult(term: String, completed: @escaping (Result<MediaSearchResult, iTunseError>) -> Void)
    func downloadImage(from urlString: String, completed: @escaping (UIImage?) -> Void)
}

class NetworkManager: NetworkManagerProtocol {
    static let shared = NetworkManager()
    let baseURL       = "https://itunes.apple.com/search?entity=movie,podcast,album&term="
    let baseLookupURL = "https://itunes.apple.com/lookup?entity=album&limit=5&amgArtistId="
    let cache         = NSCache<NSString, UIImage>()
    
    func getMediaSearchResult(term: String, completed: @escaping (Result<MediaSearchResult, iTunseError>) -> Void) {
        let searchString = term.replacingOccurrences(of: " ", with: "+")
        let endpoint     = "\(baseURL)\(searchString)"
        
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
                decoder.keyDecodingStrategy  = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .iso8601
                let mediaSearchResult = try decoder.decode(MediaSearchResult.self, from: data)
                completed(.success(mediaSearchResult))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
    
    func getMediaLookupResult(amgArtist id: Int?, completed: @escaping (Result<MediaSearchResult, iTunseError>) -> Void) {
        guard let idAmg = id else { return }
        let endpoint     = "\(baseLookupURL)\(idAmg)"
        
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
                decoder.keyDecodingStrategy  = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .iso8601
                let mediaSearchResult = try decoder.decode(MediaSearchResult.self, from: data)
                completed(.success(mediaSearchResult))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
    
    func downloadImage(from urlString: String, completed: @escaping (UIImage?) -> Void) {
        let cacheKey    = NSString(string: urlString)
        let hdURLString = urlString.replacingOccurrences(of: "100", with: "500")
        if let image = cache.object(forKey: cacheKey) {
            completed(image)
            return
        }
        guard let url = URL(string: hdURLString) else {
            completed(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                  error == nil,
                  let response = response as? HTTPURLResponse,response.statusCode == 200,
                  let data = data,
                  let image = UIImage(data: data) else {
                completed(nil)
                return
            }
            self.cache.setObject(image, forKey: cacheKey)
            completed(image)
        }
        task.resume()
    }
}
