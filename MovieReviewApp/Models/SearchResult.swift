//
//  Results.swift
//  MovieReviewApp
//
//  Created by Amer Abboud on 1/7/21.
//  Copyright © 2021 Amer Abboud. All rights reserved.
//

import Foundation

struct SearchResult: Codable, Hashable {
    let Search: [Movie]
    let totalResults: String
}
