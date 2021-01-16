//
//  WatchListViewController.swift
//  MovieReviewApp
//
//  Created by Amer Abboud on 1/7/21.
//  Copyright © 2021 Amer Abboud. All rights reserved.
//

import UIKit

class WatchlistVC: UIViewController {
    
    let tableView = UITableView()
    var movies: [Movie] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getWatchlist()
    }
    
    func getWatchlist() {
        PersistenceManager.retrieveWatchlist {[weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let movies):
                self.movies = movies
                self.tableView.reloadDataOnMainThread()
            case .failure(let error):
                DispatchQueue.main.async {
                    let alertVC = UIAlertController(title: "Unable to get watchlist", message: error.rawValue, preferredStyle: .alert)
                    alertVC.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
                    self.present(alertVC, animated: true)
                }
            }
        }
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        
        tableView.removeExcessCells()
        tableView.frame = view.bounds
        tableView.rowHeight = 144
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(WatchlistCell.self, forCellReuseIdentifier: WatchlistCell.reuseID)
    }
}

extension WatchlistVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WatchlistCell.reuseID) as! WatchlistCell
        let movie = movies[indexPath.row]
        cell.set(movie: movie)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let movieDetailsVC = MovieDetailsVC()
        movieDetailsVC.passedMovie = movies[indexPath.row]
         movieDetailsVC.movie = movies[indexPath.row]
        let navigationController = UINavigationController(rootViewController: movieDetailsVC)
        navigationController.navigationItem.rightBarButtonItem = nil
        present(navigationController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let movie = movies[indexPath.row]
        movies.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .left)
        PersistenceManager.updateWith(movie: movie, actionType: .remove) {[weak self] (error) in
            guard let self = self else { return }
            
            guard let error = error else { return }
            
            DispatchQueue.main.async {
                let alertVC = UIAlertController(title: "Unable to delete", message: error.rawValue, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
                self.present(alertVC, animated: true)
            }
        }
    }
}
