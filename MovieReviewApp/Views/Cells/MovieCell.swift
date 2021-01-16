//
//  MovieCell.swift
//  MovieReviewApp
//
//  Created by Amer Abboud on 1/7/21.
//  Copyright © 2021 Amer Abboud. All rights reserved.
//

import UIKit

class MovieCell: UICollectionViewCell {
    
    static let reuseID = "MovieCell"
    
    let posterImageView = MRPosterImageView(frame: .zero)
    let movieTitleLabel = MRTitleLabel(textAlignment: .center, fontSize: 16)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        posterImageView.image = nil
        movieTitleLabel.text = nil
        super.prepareForReuse()
    }
    
    func set(movie: Movie) {
        movieTitleLabel.text = movie.Title
        posterImageView.downloadImage(from: movie.Poster)
    }
    
    
    func configure() {
        addSubview(posterImageView)
        addSubview(movieTitleLabel)
        
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            posterImageView.heightAnchor.constraint(equalTo: posterImageView.widthAnchor, multiplier: 1.5),
            
            movieTitleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 12),
            movieTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            movieTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
        ])
    }
}
