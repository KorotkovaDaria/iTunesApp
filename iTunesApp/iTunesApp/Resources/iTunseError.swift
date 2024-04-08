//
//  iTunseError.swift
//  iTunesApp
//
//  Created by Daria on 07.04.2024.
//

import Foundation

enum iTunseError: String, Error {
    case invalidURL        = "This url created an invalid request. Please try again."
    case unableToComplete  = "Unable to complete your request. Please check your internet connection"
    case invalidResponse   = "Invalid response from the server. Please try again."
    case invalidData       = "The data received from the server was invalid. Please try again."
}
