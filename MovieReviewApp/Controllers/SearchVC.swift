//
//  SearchViewController.swift
//  MovieReviewApp
//
//  Created by Amer Abboud on 1/7/21.
//  Copyright © 2021 Amer Abboud. All rights reserved.
//

import UIKit

class SearchVC: UIViewController {
    
    let logoImageView = UIImageView()
    let movieTitleTextField = MRTextField()
    let movieSearchButton = MRSearchButton(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        createDismissKeyboardTapGesture()
        configureLogoImageView()
        configureMovieTitleTextField()
        configureMovieSearchButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        movieTitleTextField.text = ""
    }
    
    func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    func configureLogoImageView() {
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = UIImage(named: "logo")
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 5/8),
            logoImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 5/8)
        ])
    }
    
    func configureMovieTitleTextField() {
        view.addSubview(movieTitleTextField)
        
        movieTitleTextField.placeholder = "Enter movie title"
        
        NSLayoutConstraint.activate([
            movieTitleTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            movieTitleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            movieTitleTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3/4),
            movieTitleTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configureMovieSearchButton() {
        view.addSubview(movieSearchButton)
        
        movieSearchButton.addTarget(self, action: #selector(pushMovieSearchResultVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            movieSearchButton.centerYAnchor.constraint(equalTo: movieTitleTextField.centerYAnchor),
            movieSearchButton.leadingAnchor.constraint(equalTo: movieTitleTextField.trailingAnchor, constant: 12),
            movieSearchButton.widthAnchor.constraint(equalToConstant: 50),
            movieSearchButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func pushMovieSearchResultVC() {
        guard let movieTitle = movieTitleTextField.text else { return }
        if movieTitleTextField.text == "" {
            return
        }
        movieTitleTextField.resignFirstResponder()
        let searchResultVC = SearchResultVC()
        searchResultVC.searchedTitle = movieTitle
        navigationController?.pushViewController(searchResultVC, animated: true)
    }
}
