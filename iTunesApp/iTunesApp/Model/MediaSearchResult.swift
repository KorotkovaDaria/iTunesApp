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
    let trackID: Int?
    let artistName: String
    let trackName, trackCensoredName: String?
    let trackViewURL: String?
    let previewURL: String?
    let artworkUrl30: String?
    let artworkUrl60, artworkUrl100: String?
    let collectionPrice: Double?
    let trackPrice, trackRentalPrice: Double?
    let collectionExplicitness: String
    let trackExplicitness: String?
    let trackTimeMillis: Int?
    let country, currency, primaryGenreName: String?
    let contentAdvisoryRating, shortDescription, longDescription: String?
    let artistID, collectionID: Int?
    let collectionName, collectionCensoredName: String?
    let artistViewURL, collectionViewURL: String?
    let trackCount: Int?
    let description: String?
    let collectionHDPrice, trackHDPrice, trackHDRentalPrice: Double?
}
