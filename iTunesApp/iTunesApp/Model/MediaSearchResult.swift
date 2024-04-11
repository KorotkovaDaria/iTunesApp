//
//  MediaSearchResult.swift
//  iTunesApp
//
//  Created by Daria on 07.04.2024.

import Foundation

// MARK: - MediaSearchResult
struct MediaSearchResult: Codable, Hashable {
    let resultCount: Int
    let results:     [MediaResult]
}

// MARK: - MediaResult
struct MediaResult: Codable, Hashable {
    let wrapperType:             String
    let kind:                    String?
    
    let artistName:              String
    let artistViewUrl:           String?
    let artistId:                Int?
    let amgArtistId:             Int?
    
    let collectionType:          String?
    let collectionName:          String?
    let collectionId:            Int?
    let collectionArtistName:    String?
    let collectionArtistViewUrl: String?
    let collectionArtistID:      Int?
    let collectionArtistViewURL: String?
    let collectionViewUrl:       String?
    
    let trackId:                 Int?
    let trackName:               String?
    let trackCensoredName:       String?
    let trackViewUrl:            String?
    let trackCount:              Int?
    let trackNumber:             Int?
    
    let discCount:               Int?
    let discNumber:              Int?
    
    let artworkUrl60:            String?
    let artworkUrl100:           String?
    
    let previewUrl:              String?
    
    let collectionPrice:         Double?
    let trackPrice:              Double?
    
    let trackTimeMillis:         Int?
    let releaseDate:             Date?
    
    let shortDescription:        String?
    let longDescription:         String?
    let description:             String?
}
