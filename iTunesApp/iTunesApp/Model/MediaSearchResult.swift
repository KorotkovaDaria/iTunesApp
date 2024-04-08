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
    let trackId: Int?
    let artistName: String
    let trackName, trackCensoredName: String?
    let trackViewUrl: String?
    let artistViewUrl: String?
    let collectionArtistViewUrl: String?
    let previewUrl: String?
    let artworkUrl60, artworkUrl100: String?
    let collectionPrice: Double?
    let trackTimeMillis: Int?
    let shortDescription, longDescription: String?
    let artistId, collectionId: Int?
    let collectionName, collectionCensoredName: String?
    let trackCount: Int?
    let description: String?
}
