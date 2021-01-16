//
//  MovieDetailVC.swift
//  MovieReviewApp
//
//  Created by Amer Abboud on 1/9/21.
//  Copyright © 2021 Amer Abboud. All rights reserved.
//

import UIKit

class MovieDetailsVC: UIViewController {
    
    var movieTitle: String!
    var movieID: String!
    
    let posterImageView = MRPosterImageView(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        title = movieTitle
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func addButtonTapped() {
        
    }
}
