//
//  NetworkManager.swift
//  MovieReviewApp
//
//  Created by Amer Abboud on 1/7/21.
//  Copyright © 2021 Amer Abboud. All rights reserved.
//

import UIKit

class NetworkManager {
    
    static let shared = NetworkManager()
    private let baseURL = "https://www.omdbapi.com/?apikey=56c659e3&"
    
    let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func getMovieSearchResults(for movie: String, page: Int, completion: @escaping (Result<SearchResult, MRError>) -> Void) {
        let query = movie.replacingOccurrences(of: " ", with: "%20").replacingOccurrences(of: "’", with: "%27")
        
        let endpoint = baseURL + "s=\(query)&type=movie&page=\(page)&plot=full"

        guard let url = URL(string: endpoint) else {
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                completion(.failure(.unableToComplete))
                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.unableToComplete))
                return
            }

            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }

            do {
                let results = try JSONDecoder().decode(SearchResult.self, from: data)
                completion(.success(results))
            } catch {
                completion(.failure(.invalidData))
            }
        }.resume()
    }
    
    func getMovieDetails(id: String, completion: @escaping (Result<Movie, MRError>) -> Void) {
        let endpoint = baseURL + "i=\(id)"

         guard let url = URL(string: endpoint) else {
             return
         }

         URLSession.shared.dataTask(with: url) { (data, response, error) in
             if error != nil {
                 completion(.failure(.unableToComplete))
                 return
             }

             guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                 completion(.failure(.unableToComplete))
                 return
             }

             guard let data = data else {
                 completion(.failure(.invalidData))
                 return
             }

             do {
                 let movie = try JSONDecoder().decode(Movie.self, from: data)
                 completion(.success(movie))
             } catch {
                 completion(.failure(.invalidData))
             }
         }.resume()
    }
}
