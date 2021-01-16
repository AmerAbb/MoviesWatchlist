//
//  MovieDetailVC.swift
//  MovieReviewApp
//
//  Created by Amer Abboud on 1/9/21.
//  Copyright © 2021 Amer Abboud. All rights reserved.
//

import UIKit
import SafariServices

class MovieDetailsVC: UIViewController {
    
    var passedMovie: Movie!
    var movie: Movie!
    
    let posterImageView = MRPosterImageView(frame: .zero)
    
    let stackView = UIStackView()
    let yearLabel = MRSecondaryTitleLabel(textAlignment: .center, fontSize: 14)
    let ratingLabel = MRSecondaryTitleLabel(textAlignment: .center, fontSize: 14)
    let ratedLabel = MRSecondaryTitleLabel(textAlignment: .center, fontSize: 14)
    let runtimeLabel = MRSecondaryTitleLabel(textAlignment: .center, fontSize: 14)
    
    let genreLabel = MRSecondaryTitleLabel(textAlignment: .left, fontSize: 14)
    let plotLabel = MRTitleLabel(textAlignment: .left, fontSize: 18)
    
    let imdbLinkButton = UIButton()


    override func viewDidLoad() {
        super.viewDidLoad()
        getMovieDetails()
    }
    
    func configureAllViews() {
        configureViewController()
        configurePosterImageView()
        configureStackView()
        configureInfoLabel()
        configureImdbLinkButton()
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        title = movie.Title
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    func getMovieDetails() {
        NetworkManager.shared.getMovieDetails(id: passedMovie.imdbID) {[weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let movie):
                self.movie = movie
                DispatchQueue.main.async {
                    self.configureAllViews()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    //?
                    let alertVC = UIAlertController(title: "Unable to fetch movie details", message: error.rawValue, preferredStyle: .alert)
                    alertVC.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { (action) in
                        self.dismiss(animated: true)
                    }))
                    self.present(alertVC, animated: true)
                }
            }
        }
    }
    
    func configurePosterImageView() {
        view.addSubview(posterImageView)
        posterImageView.downloadImage(from: movie.Poster)
        
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            posterImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            posterImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3/4),
            posterImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/2)
        ])
    }
    
    private func configureStackView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        yearLabel.text = movie.Year
        ratingLabel.text = movie.imdbRating
        ratedLabel.text = movie.Rated
        runtimeLabel.text = movie.Runtime
        stackView.addArrangedSubview(yearLabel)
        stackView.addArrangedSubview(ratingLabel)
        stackView.addArrangedSubview(ratedLabel)
        stackView.addArrangedSubview(runtimeLabel)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 12),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.widthAnchor.constraint(equalTo: posterImageView.widthAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    //rename?
    private func configureInfoLabel() {
        view.addSubview(genreLabel)
        view.addSubview(plotLabel)
        
        genreLabel.numberOfLines = 0
        plotLabel.numberOfLines = 0
        genreLabel.text = movie.Genre
        plotLabel.text = movie.Plot
        plotLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        
        NSLayoutConstraint.activate([
            genreLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 0),
            genreLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            genreLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            genreLabel.heightAnchor.constraint(equalToConstant: 30),
            
            plotLabel.topAnchor.constraint(equalTo: genreLabel.bottomAnchor, constant: 60),
            plotLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            plotLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
        ])
    }
    
    private func configureImdbLinkButton() {
        view.addSubview(imdbLinkButton)
        
        imdbLinkButton.translatesAutoresizingMaskIntoConstraints = false
        imdbLinkButton.addTarget(self, action: #selector(imdbLinkButtonTapped), for: .touchUpInside)
        imdbLinkButton.setTitle("Go to IMDb Page", for: UIControl.State.normal)
        imdbLinkButton.setTitleColor(.systemYellow, for: UIControl.State.normal)
        
        NSLayoutConstraint.activate([
            imdbLinkButton.topAnchor.constraint(equalTo: plotLabel.bottomAnchor, constant: 60),
            imdbLinkButton.leadingAnchor.constraint(equalTo: plotLabel.leadingAnchor),
            imdbLinkButton.trailingAnchor.constraint(equalTo: plotLabel.trailingAnchor),
            imdbLinkButton.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    @objc func imdbLinkButtonTapped() {
        guard let url = URL(string: "https://www.imdb.com/title/\(movie.imdbID)") else { return }
        let imdbPage = SFSafariViewController(url: url)
        imdbPage.preferredControlTintColor = .systemYellow
        present(imdbPage, animated: true)
    }
    
    @objc func addButtonTapped() {
        showLoadingView()
        NetworkManager.shared.getMovieDetails(id: movie.imdbID) {[weak self] (result) in
            guard let self = self else { return }
            self.dismissLoadingView()
            switch result {
            case .success(let movie):
                PersistenceManager.updateWith(movie: movie, actionType: .add) {[weak self] (error) in
                    guard let self = self else { return }
                    guard let error = error else {
                        DispatchQueue.main.async {
                            let alertVC = UIAlertController(title: "Success!", message: "Successfully added to your watchlist!", preferredStyle: .alert)
                            self.present(alertVC, animated: true)
                            let delay = DispatchTime.now() + 1.5
                            DispatchQueue.main.asyncAfter(deadline: delay) {
                              alertVC.dismiss(animated: true)
                            }
                        }
                        return
                    }
                    DispatchQueue.main.async {
                        let alertVC = UIAlertController(title: "Unable to add to watchlist", message: error.rawValue, preferredStyle: .alert)
                        alertVC.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
                        self.present(alertVC, animated: true)
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    let alertVC = UIAlertController(title: "Unable to add to watchlist", message: error.rawValue, preferredStyle: .alert)
                    alertVC.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
                    self.present(alertVC, animated: true)
                }
            }
        }
    }
    
    @objc func cancelButtonTapped() {
        self.dismiss(animated: true)
    }
}
