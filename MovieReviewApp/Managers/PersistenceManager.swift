//
//  PersistenceManager.swift
//  MovieReviewApp
//
//  Created by Amer Abboud on 1/9/21.
//  Copyright © 2021 Amer Abboud. All rights reserved.
//

import Foundation

enum PersistenceActionType {
    case add, remove
}

struct PersistenceManager {
    
    enum Keys {
        static let watchlist = "watchlist"
    }
    
    static private let defaults = UserDefaults.standard
    
    static func updateWith(movie: Movie, actionType: PersistenceActionType, completion: @escaping (MRError?) -> Void) {
        retrieveWatchlist { (result) in
            switch result {
            case .success(let watchlist):
                var retrieveWatchlist = watchlist
                
                switch actionType {
                case .add:
                    guard !retrieveWatchlist.contains(movie) else {
                        completion(.alreadyInWatchlist)
                        return
                    }
                    retrieveWatchlist.append(movie)
                case .remove:
                    retrieveWatchlist.removeAll { $0.imdbID == movie.imdbID }
                }
                
                completion(save(watchlist: retrieveWatchlist))
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    static func retrieveWatchlist(completion: @escaping (Result<[Movie], MRError>) -> Void) {
        guard let watchlistData = defaults.object(forKey: Keys.watchlist) as? Data else {
            completion(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let watchlist = try decoder.decode([Movie].self, from: watchlistData)
            completion(.success(watchlist))
        } catch {
            completion(.failure(.unableToAddToWatchlist))
        }
    }
    
    static func save(watchlist: [Movie]) -> MRError? {
        do {
            let encoder = JSONEncoder()
            let encodedWatchlist = try encoder.encode(watchlist)
            defaults.set(encodedWatchlist, forKey: Keys.watchlist)
            return nil
        } catch {
            return .unableToAddToWatchlist
        }
    }
}

