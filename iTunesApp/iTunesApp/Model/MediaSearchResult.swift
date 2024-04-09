//
//  MediaSearchResult.swift
//  iTunesApp
//
//  Created by Daria on 07.04.2024.

import Foundation

// MARK: - MediaSearchResult
struct MediaSearchResult: Codable, Hashable {
    let resultCount: Int
    let results: [MediaResult]
}

// MARK: - MediaResult
struct MediaResult: Codable, Hashable {
    let wrapperType: String
    let kind: String?
    
    let artistName: String
    let artistViewUrl: String?
    let artistId: Int?
    
    let collectionName: String?
    let collectionCensoredName: String?
    let collectionId: Int?
    let collectionArtistViewUrl: String?
    
    let trackId: Int?
    let trackName: String?
    let trackCensoredName: String?
    let trackViewUrl: String?
    
    let artworkUrl60: String?
    let artworkUrl100: String?
    
    let previewUrl: String?
    
    let collectionPrice: Double?
    
    let trackTimeMillis: Int?
    let releaseDate: String?
    
    let shortDescription: String?
    let longDescription: String?
    let description: String?
}
