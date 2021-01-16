//
//  MRError.swift
//  MovieReviewApp
//
//  Created by Amer Abboud on 1/7/21.
//  Copyright © 2021 Amer Abboud. All rights reserved.
//

import Foundation

enum MRError: String, Error {
    case unableToComplete = "Unable to complete your request. Please check your internet connection."
    case invalidResponse = "Invalid response from the server. Please try again."
    case invalidData = "The data received from the server was invalid. Please try again."
    case unableToAddToWatchlist = "There was an error adding this movie to your watchlist. Please try again."
    case alreadyInWatchlist = "You already added this movie to your watchlist."
}
