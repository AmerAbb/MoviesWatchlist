//
//  SearchResultVC.swift
//  MovieReviewApp
//
//  Created by Amer Abboud on 1/7/21.
//  Copyright © 2021 Amer Abboud. All rights reserved.
//

import UIKit

class SearchResultVC: UIViewController {
    
    var searchedTitle  = ""
    var searchResult: [Movie] = []
    var totalSearchResult = 0
    var page = 1
    var containsMoreResults = true
    
    var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        getSearchResult(page: page)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func getSearchResult(page: Int) {
        if self.searchResult.count == totalSearchResult && page != 1{
            self.containsMoreResults = false
            return
        }
        showLoadingView()
        NetworkManager.shared.getMovieSearchResults(for: searchedTitle, page: page) {[weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()
            
            switch result {
            case .success(let searchResult):
                self.totalSearchResult = Int(searchResult.totalResults) ?? 0
                self.searchResult.append(contentsOf: searchResult.Search)
                DispatchQueue.main.async { self.collectionView.reloadData() }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    let alertVC = UIAlertController(title: "No results", message: error.rawValue, preferredStyle: .alert)
                    self.present(alertVC, animated: true)
                    alertVC.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { (action) in
                        self.navigationController?.popViewController(animated: true)
                    }))
                }
            }
        }
    }
    
    func configureViewController() {
        title = "' \(searchedTitle) '"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.reuseID)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

extension SearchResultVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.reuseID, for: indexPath) as! MovieCell
        let result = searchResult[indexPath.item]
//        let posterUrl = (result.Poster != "N/A" ? result.Poster : "")!
//        cell.set(movieTitle: result.Title, posterUrl: posterUrl)
        cell.set(movie: result)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieDetailsVC = MovieDetailsVC()
        NetworkManager.shared.getMovieDetails(id: searchResult[indexPath.item].imdbID) {[weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let movie):
                movieDetailsVC.passedMovie = movie
                DispatchQueue.main.async {
                    self.present(UINavigationController(rootViewController: movieDetailsVC), animated: true)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    let alertVC = UIAlertController(title: "Unable to fetch movie details", message: error.rawValue, preferredStyle: .alert)
                    alertVC.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { (action) in
                        self.dismiss(animated: true)
                    }))
                    self.present(alertVC, animated: true)
                }
            }
        }
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height && containsMoreResults{
            page += 1
            getSearchResult(page: page)
        }
    }
}
