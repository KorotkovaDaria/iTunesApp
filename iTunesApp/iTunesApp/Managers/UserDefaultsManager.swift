//
//  UserDefaultsManager.swift
//  iTunesApp
//
//  Created by Daria on 09.04.2024.
//

import Foundation

struct UserDefaultsManager {
    
    static let shared        = UserDefaultsManager()
    private let userDefaults = UserDefaults.standard
    let key                  = "PreviouslyEnteredSearchTerms"
    
    private init() {}
    
    func saveSearchTerms(_ terms: [String]) {
        userDefaults.set(terms, forKey: key)
    }
    
    func loadSearchTerms() -> [String] {
        if let savedSearchTerms = userDefaults.array(forKey: key) as? [String] {
            return savedSearchTerms
        }
        return []
    }
}

