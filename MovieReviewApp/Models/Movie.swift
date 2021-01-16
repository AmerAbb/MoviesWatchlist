//
//  Movie.swift
//  MovieReviewApp
//
//  Created by Amer Abboud on 1/7/21.
//  Copyright © 2021 Amer Abboud. All rights reserved.
//

import Foundation

struct Movie: Codable, Hashable {
    let Title: String
    let Released: String?
    let Year: String?
    let Rated: String?
    let Runtime: String?
    let Genre: String?
    let Plot: String?
    let imdbRating: String?
    let imdbID: String
    let Poster: String
}

