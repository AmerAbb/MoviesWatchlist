//
//  WatchlistCell.swift
//  MovieReviewApp
//
//  Created by Amer Abboud on 1/9/21.
//  Copyright © 2021 Amer Abboud. All rights reserved.
//

import UIKit

class WatchlistCell: UITableViewCell {
    
    static let reuseID = "WatchlistCell"
    
    let posterImageView = MRPosterImageView(frame: .zero)
    let titleLabel = MRTitleLabel(textAlignment: .left, fontSize: 16)
    let genreLabel = MRSecondaryTitleLabel(textAlignment: .left, fontSize: 14)
    let ratingLabel = MRSecondaryTitleLabel(textAlignment: .left, fontSize: 14)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(movie: Movie) {
        posterImageView.downloadImage(from: movie.Poster)
        titleLabel.text = movie.Title
        genreLabel.text = movie.Genre
        ratingLabel.text = movie.imdbRating
    }
    
    private func configure() {
        addSubview(posterImageView)
        addSubview(titleLabel)
        addSubview(genreLabel)
        addSubview(ratingLabel)
        accessoryType = .disclosureIndicator
        
        let padding = CGFloat(12)
        
        NSLayoutConstraint.activate([
            posterImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            posterImageView.heightAnchor.constraint(equalToConstant: 120),
            posterImageView.widthAnchor.constraint(equalToConstant: 80),
            
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 20),
            
            genreLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding),
            genreLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: padding),
            genreLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            genreLabel.heightAnchor.constraint(equalToConstant: 18),
            
            ratingLabel.topAnchor.constraint(equalTo: genreLabel.bottomAnchor, constant: padding),
            ratingLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: padding),
            ratingLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            ratingLabel.heightAnchor.constraint(equalToConstant: 18),
        ])
    }
    
}
